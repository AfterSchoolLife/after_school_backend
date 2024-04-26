class Api::V1::Auth::CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    carts = Cart.includes(:product, :schedule).where(user_id: current_user.id)
    students = Student.where(is_active: true, user_id: current_user.id)
    render json: { 
      user: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
      cart: carts.as_json(include: [:product, { schedule: { include: [:program, :school] } }]),
      student: students.as_json(only: [:id, :firstname, :lastname, :age, :grade,:pickup, :address, :city, :state, :zip])
    }, status: :ok
  end
end
