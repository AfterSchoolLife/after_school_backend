# app/controllers/api/v1/auth/confirmations_controller.rb
class Api::V1::Auth::ConfirmationsController < ApplicationController
    def confirm
      user = User.confirm_by_token(params[:confirmation_token])
      if user.errors.empty?
        render json: { message: "Your account has been confirmed successfully." }, status: :ok
      else
        render json: { error: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  end
  