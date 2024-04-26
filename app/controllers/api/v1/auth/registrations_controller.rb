# # frozen_string_literal: true

# class Users::RegistrationsController < Devise::RegistrationsController
#   # before_action :configure_sign_up_params, only: [:create]
#   # before_action :configure_account_update_params, only: [:update]

#   # GET /resource/sign_up
#   # def new
#   #   super
#   # end

#   # POST /resource
#   # def create
#   #   super
#   # end

#   # GET /resource/edit
#   # def edit
#   #   super
#   # end

#   # PUT /resource
#   # def update
#   #   super
#   # end

#   # DELETE /resource
#   # def destroy
#   #   super
#   # end

#   # GET /resource/cancel
#   # Forces the session data which is usually expired after sign
#   # in to be expired now. This is useful if the user wants to
#   # cancel oauth signing in/up in the middle of the process,
#   # removing all OAuth session data.
#   # def cancel
#   #   super
#   # end

#   # protected

#   # If you have extra params to permit, append them to the sanitizer.
#   # def configure_sign_up_params
#   #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
#   # end

#   # If you have extra params to permit, append them to the sanitizer.
#   # def configure_account_update_params
#   #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
#   # end

#   # The path used after sign up.
#   # def after_sign_up_path_for(resource)
#   #   super(resource)
#   # end

#   # The path used after sign up for inactive accounts.
#   # def after_inactive_sign_up_path_for(resource)
#   #   super(resource)
#   # end
#   respond_to :json
# end

class Api::V1::Auth::RegistrationsController < Devise::RegistrationsController
  include RackSessionFix
  before_action :authenticate_user!, only: [:createAdmin]
  before_action :user_params, only: [:create]
  def create
    begin
      build_resource(user_params.merge(role: 'user'))
      resource.save
      if resource.persisted?
        UsermailerMailer.welcome_email(resource).deliver_later
        render json: {
        status: {code: 200, message: "Signed up sucessfully."},
        data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
        }, status: :ok
      else
      render json: {
        status: {code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
      }, status: :unprocessable_entity
    end
    rescue StandardError => e
      render json: {error: "Failed to Create user" , messge: e.message}, status: :unprocessable_entity
    end
  end

  def createAdmin
    begin
        if current_user.role == 'super-admin'
          build_resource(user_params.merge(role: 'admin',parent_1_name: 'NA', parent_1_relation: 'NA', parent_1_phone_number: 'NA', emergency_1_name: 'NA', emergency_1_relation: 'NA', emergency_1_phone_number: 'NA'))
          resource.save
          if resource.persisted?
              UsermailerMailer.welcome_email(resource).deliver_later
              render json: {
              status: {code: 200, message: "Signed up sucessfully."},
              data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
              }, status: :ok
          else
              render json: {
              status: {code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
              }, status: :unprocessable_entity
          end
        else
          render json: { error: 'You do not have access' }, status: :unprocessable_entity
        end
    rescue StandardError => e
        render json: {error: "Failed to Create user" , messge: e.message}, status: :unprocessable_entity
    end
  end

  def destroy
    super do |resource|
      render json: {
        status: { code: 200, message: "Account deleted successfully." }
      }, status: :ok
    end
  end
  private
  def user_params
    params.require(:user).permit(:email, :password, :parent_1_name, :parent_2_name, :parent_1_phone_number, :parent_2_phone_number, :parent_1_relation, :parent_2_relation, :emergency_1_name, :emergency_2_name, :emergency_1_relation, :emergency_2_relation, :emergency_1_phone_number, :emergency_2_phone_number)
  end

end

# def respond_with(resource, _opts = {})
#     if request.method == "POST" && resource.persisted?
#       render json: {
#         status: {code: 200, message: "Signed up sucessfully."},
#         data: UserSerializer.new(resource).serializable_hash[:data][:attributes]
#       }, status: :ok
#     elsif request.method == "DELETE"
#       render json: {
#         status: { code: 200, message: "Account deleted successfully."}
#       }, status: :ok
#     else
#       render json: {
#         status: {code: 422, message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"}
#       }, status: :unprocessable_entity
#     end
#   end