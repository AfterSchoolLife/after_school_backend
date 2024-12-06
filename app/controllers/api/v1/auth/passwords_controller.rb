class Api::V1::Auth::PasswordsController < ApplicationController
            def forgot
                user = User.find_by(email: params[:email])
                if user
                    user.send_reset_password_instructions
                    render json: { message: "Password reset instructions have been sent to your email." }, status: :ok
                else
                    render json: { error: "Email not found" }, status: :not_found
                end
            end

            def reset
                user = User.reset_password_by_token(reset_password_params)
                if user.errors.empty?
                    render json: { message: "Password has been reset successfully." }, status: :ok
                else
                    render json: { error: user.errors.full_messages }, status: :unprocessable_entity
                end
            end
  

            # GET /api/v1/auth/password/edit?reset_password_token=token
            def edit
                @reset_password_token = params[:reset_password_token]
                # This action typically renders a view with the reset password form,
                # but since we're using React, it will be handled on the frontend.
            end

            # POST /api/v1/auth/password/reset
            def update
                user = User.reset_password_by_token(reset_password_params)
                if user.errors.empty?
                render json: { message: "Password successfully reset" }, status: :ok
                else
                render json: { error: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
                end
            end

            private

            def reset_password_params
                params.require(:user).permit(:reset_password_token, :password, :password_confirmation)
            end

            protected

            def after_sending_reset_password_instructions_path_for(resource_name)
              # Modify the reset link to point to your React app's reset page
              edit_password_url = "https://after-school-frontend-tio8.vercel.app/auth/reset?reset_password_token=#{resource.reset_password_token}"
            #   edit_password_url = "http://localhost:3000/auth/reset?reset_password_token=#{resource.reset_password_token}"
              # Send the modified reset link in the email
            end

end
  