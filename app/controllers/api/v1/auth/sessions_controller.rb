# # frozen_string_literal: true

# class Users::SessionsController < Devise::SessionsController
#   # before_action :configure_sign_in_params, only: [:create]

#   # GET /resource/sign_in
#   # def new
#   #   super
#   # end

#   # POST /resource/sign_in
#   # def create
#   #   super
#   # end

#   # DELETE /resource/sign_out
#   # def destroy
#   #   super
#   # end

#   # protected

#   # If you have extra params to permit, append them to the sanitizer.
#   # def configure_sign_in_params
#   #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
#   # end
#   respond_to :json
# end

class Api::V1::Auth::SessionsController < Devise::SessionsController
  include RackSessionFix
  # respond_to :json
  def create
    begin
      super do |user|
        if user.persisted?
          puts user.email
          # token = JWT.encode({ user_id: user.id }, Rails.application.credentials.secret_key_base)
          render json: user
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
        return
      end
    rescue StandardError => e
      render json: {error: "Failed to Create School" , messge: e.message}, status: :unprocessable_entity
    end
  end


end
  # private

  # def respond_with(resource, _opts = {})
    # render json: {
    #   status: {code: 200, message: 'Logged in sucessfully.'},
    #   data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
    # }, status: :ok
  # end

#   def respond_to_on_destroy
#     if current_user
#       render json: {
#         status: 200,
#         message: "logged out successfully"
#       }, status: :ok
#     else
#       render json: {
#         status: 401,
#         message: "Couldn't find an active session."
#       }, status: :unauthorized
#     end
#   end
# end