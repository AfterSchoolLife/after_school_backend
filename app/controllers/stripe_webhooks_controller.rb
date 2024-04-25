class StripeWebhooksController < ApplicationController
    # app/controllers/stripe_webhooks_controller.rb
    skip_before_action :verify_authenticity_token
    skip_before_action :authenticate_user!, raise: false
  
    def create
      endpoint_secret = Rails.application.credentials.stripe[:webhook_secret]
      payload = request.body.read
      sig_header = request.env['HTTP_STRIPE_SIGNATURE']
  
      event = nil
  
      begin
        event = Stripe::Webhook.construct_event(payload, sig_header, endpoint_secret)
      rescue JSON::ParserError => e
        render json: { message: 'Invalid payload' }, status: :bad_request
        return
      rescue Stripe::SignatureVerificationError => e
        render json: { message: 'Invalid signature' }, status: :bad_request
        return
      end
  
      # Process webhook event
      
      case event['type']
      when 'checkout.session.completed'
        session = event['data']['object']
        handle_checkout_session(session)
      end
  
      render json: { message: 'Event received' }
    end
  
    private
  
    def handle_checkout_session(session)
      user = User.find(session.metadata.user_id)
  
      # Example: Send an email if the payment was for a program registration
      if session.metadata.program_id
        program = Program.find(session.metadata.program_id)
        UserMailer.program_registration_email(user, program).deliver_later
      end
  
      # Send a general payment success email
      UserMailer.payment_successful_email(user, session.amount_total / 100.0).deliver_later
    end
  
end
