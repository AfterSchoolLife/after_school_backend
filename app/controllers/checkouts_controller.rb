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
        return_url: 'http://localhost:3000'+ '/return?session_id={CHECKOUT_SESSION_ID}',
      )
  
      render json: { clientSecret: session.client_secret, sessionId: session.id }
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :bad_request
    end

    def session_status
      session = Stripe::Checkout::Session.retrieve(params[:session_id])
      render json: { status: session.status, customer_email: session.customer_details.email }
    rescue Stripe::StripeError => e
      render json: { error: e.message }, status: :bad_request
    end

    private
  
    def current_cart
      # This method should return the cart associated with the current user
      # Assuming you have set this method up in the ApplicationController or a similar place
      @cart = Cart.where(user_id: current_user.id)
    end
  
    def generate_line_items(cart)
      @cart.map do |item|
        puts 
        {
          price_data: {
            currency: 'usd',
            product_data: {
              name: item.schedule.program.title,  # Ensure the model relationships support this
            },
            unit_amount: (item.schedule.price * 100).to_i,
          },
          quantity: 1,
        }
      end
    end

    
    
  end
  