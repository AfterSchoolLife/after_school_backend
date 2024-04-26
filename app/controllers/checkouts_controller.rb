class CheckoutsController < ApplicationController
    before_action :authenticate_user!  # Assuming you have a method to authenticate users
    before_action :current_cart, only: [:create]
    def create  # Retrieves the cart using the helper method from ApplicationController
      puts @cart
      puts 'hello'
      # Create Stripe Checkout session
      session = Stripe::Checkout::Session.create(
        payment_method_types: ['card'],
        line_items: generate_line_items(@cart),
        mode: 'payment',
        ui_mode: 'embedded',
        metadata: {
          user_id: current_user.id
        },
        return_url: 'http://localhost:3000/shop'+ '/return?session_id={CHECKOUT_SESSION_ID}',
      )
  
      render json: { clientSecret: session.client_secret, sessionId: session.id }
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :bad_request
    end

    def session_status
      session = Stripe::Checkout::Session.retrieve(params[:session_id])
      #render json: { status: session.status, customer_email: session.customer_details.email }
      if session.payment_status == 'paid'
        handle_payment_success(session)
      else
        render json: { status: 'failure', message: 'Payment not successful.' }
      end
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :bad_request
    end

    private

    def handle_payment_success(session)
      user = User.find(session.metadata.user_id)
      program_registered = false
    
      # Check for program registrations
      session.line_items.data.each do |line_item|
        if line_item.metadata && line_item.metadata.schedule_id
          program = Program.find(line_item.metadata.pro_id)
          UsermailerMailer.program_registration_email(user, program).deliver_later
          program_registered = true
        end
      end
    
      # Send a general success email
      UsermailerMailer.payment_successful_email(user).deliver_later

      message = "Payment processed and emails sent accordingly."
      message += " Registered for program." if program_registered
    
      render json: { status: 'success', message: message }
    end
  
    def current_cart
      # This method should return the cart associated with the current user
      # Assuming you have set this method up in the ApplicationController or a similar place
      @cart = Cart.where(user_id: current_user.id)
    end


    def generate_line_items(cart)
      @cart.map do |item|
        line_item = {
          price_data: {
            currency: 'usd',
            product_data: {},
            unit_amount: 0,
          },
          quantity: 1,
        }
    
        if item.cart_type == 'cart_schedule'
          line_item[:price_data][:product_data] = {
            name: "#{item.schedule.program.title} | #{item.schedule.school.name}, #{item.schedule.school.address}",
          }
          line_item[:price_data][:unit_amount] = (item.schedule.price * 100).to_i
          line_item[:metadata] = { program_id: item.schedule.program.id } # Include program ID
        elsif item.cart_type == 'cart_product'
          line_item[:price_data][:product_data] = {
            name: item.product.title,
          }
          line_item[:price_data][:unit_amount] = (item.product.price * 100).to_i
        end
    
        line_item
      end
    end
    

    
    
  end
  