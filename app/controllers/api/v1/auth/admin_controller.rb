class Api::V1::Auth::AdminController < Devise::RegistrationsController
    include RackSessionFix
    before_action :user_params, only: [:create]
    def create
        begin
            build_resource(user_params.merge(role: 'admin',parent_1_name: 'NA', parent_1_relation: 'NA', parent_1_phone_number: 'NA', emergency_1_name: 'NA', emergency_1_relation: 'NA', emergency_1_phone_number: 'NA'))
            resource.save
            if resource.persisted?
                # UsermailerMailer.welcome_email(resource).deliver_later
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
    private
        def user_params
            params.require(:user).permit(:email, :password, :country)
        end
end