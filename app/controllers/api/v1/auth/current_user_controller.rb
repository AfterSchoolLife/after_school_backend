class Api::V1::Auth::CurrentUserController < ApplicationController
  before_action :authenticate_user!
  def index
    carts = Cart.includes(:product, :schedule).where(user_id: current_user.id)
    students = Student.where(is_active: true, user_id: current_user.id)
  
    # Modify cart data to include the updated product image_url if an image is attached
    carts_data = carts.map do |cart|
      cart_json = cart.as_json(include: [:product, { schedule: { include: [:program, :school] } }])
  
      # Check if product has an attached image and update image_url accordingly
      product = cart_json['product']
      if product && cart.product.image.attached?
        product['image_url'] = url_for(cart.product.image)
      elsif product
        # Fallback to original image_url if no image attachment
        product['image_url'] ||= product['image_url']
      end
  
      # Check if program and image are present in schedule and update program image_url
      program = cart_json.dig('schedule', 'program')
      if program && cart.schedule.program.image.attached?
        program['image_url'] = url_for(cart.schedule.program.image)
      end
  
      cart_json
    end
  
    render json: {
      user: UserSerializer.new(current_user).serializable_hash[:data][:attributes],
      cart: carts_data,
      student: students.as_json(only: [:id, :firstname, :lastname, :age, :grade, :pickup, :address, :city, :state, :zip])
    }, status: :ok
  end
  
  
end
