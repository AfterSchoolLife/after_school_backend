class CheckoutsController < ApplicationController
    before_action :authenticate_user!  # Assuming you have a method to authenticate users
    before_action :current_cart, only: [:create]
    def create  # Retrieves the cart using the helper method from ApplicationController
      # Create Stripe Checkout session
      begin
        session = Stripe::Checkout::Session.create(
          payment_method_types: ['card'],
          line_items: generate_line_items(),
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
    end

    def session_status
      begin
        session = Stripe::Checkout::Session.retrieve(params[:session_id])
        if session.status == 'complete'
          handle_payment_success(session,params[:session_id])
          render json: { status: session.status, customer_email: session.customer_details.email }
        else
          UsermailerMailer.(session,params[:session_id])
          render json: { status: 'failure', message: 'Payment not successful.' }
        end
      rescue Stripe::StripeError => e
        render json: { error: e.message }, status: :bad_request
      end
    end

    private

    def handle_payment_success(session, session_id)
      cart = Cart.where(user_id: session.metadata.user_id)
      user = User.find_by(id: session.metadata.user_id)
      cart.each do |item|
        if item.cart_type == 'cart_schedule'
          UsermailerMailer.program_registration_email(user, "#{item.schedule.program.title} | #{item.schedule.school.name}, #{item.schedule.school.address}").deliver_later
        end
      end
      UsermailerMailer.payment_successful_email(user).deliver_later
    end
  
    def current_cart
      # This method should return the cart associated with the current user
      # Assuming you have set this method up in the ApplicationController or a similar place
      @cart = Cart.where(user_id: current_user.id)
    end


    def generate_line_items()
      lineitem = @cart.map do |item|
        line_item = {
          price_data: {
            currency: 'usd',
            product_data: {},
            unit_amount: 0,
          },
          metadata: {},
          quantity: 1,
        }
        if current_user.country == 'usa'
            line_item[:price_data][:currency] = 'usd'
        elsif
            line_item[:price_data][:currency] = 'cad'
        end
        if item.cart_type == 'cart_schedule'
          line_item[:price_data][:product_data] = {
            name: "#{item.schedule.program.title} | #{item.schedule.school.name}, #{item.schedule.school.address}",
          }
          line_item[:price_data][:unit_amount] = (item.schedule.price * 100).to_i
        elsif item.cart_type == 'cart_product'
          line_item[:price_data][:product_data] = {
            name: item.product.title,
          }
          line_item[:price_data][:unit_amount] = (item.product.price * 100).to_i
        end
    
        line_item
      end
      lineitem
    end
        
end
  