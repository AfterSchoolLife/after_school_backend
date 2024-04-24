require 'securerandom'

class Api::V1::PurchasedsController < ApplicationController
  before_action :authenticate_user!

  def index
    begin
      purchased = Purchased.where(user_id: current_user.id)
      render json: purchased, include: [:student]
    rescue StandardError => e
      render json: {error: "Failed to Fetch order history" , messge: e.message}, status: :unprocessable_entity
    end 
  end
  def create
    gen_uuid = SecureRandom.uuid
    ActiveRecord::Base.transaction do
      purchase_items = params[:purchase_items]
      errors = []
      purchase_items.each do |item|
        permitted_params = item.permit(:schedule_id, :student_id, :purchase_uuid, :gen_uuid, :product_id, :cart_type)
        permitted_params[:user_id] = current_user.id
        permitted_params[:purchase_uuid] = gen_uuid
        if permitted_params[:schedule_id].present?
          permitted_params[:cart_type] = 'cart_schedule'
          schedule = Schedule.find_by(id: permitted_params[:schedule_id])
          if schedule.nil?
            errors << "Schedule with ID #{permitted_params[:schedule_id]} not found."
            next
          end

          if schedule.currently_available == 0
            errors << "Schedule with ID #{permitted_params[:schedule_id]} is fully booked."
            next
          end

          schedule.update(currently_available: schedule.currently_available - 1) # Update schedule availability
          puts 'hi'
          puts permitted_params
          purchase = Purchased.new(permitted_params)
          unless purchase.valid?
            errors << purchase.errors.full_messages.join(", ")
            next
          end

          begin
            purchase.save!
          rescue StandardError => e
            errors << "Error creating purchase: #{e.message}"
            raise ActiveRecord::Rollback # Roll back the transaction due to errors
          end
        else
          permitted_params[:cart_type] = 'cart_schedule'
          purchase = Purchase.new(item)

          unless purchase.valid?
            errors << purchase.errors.full_messages.join(", ")
            next
          end

          begin
            purchase.save!
          rescue StandardError => e
            errors << "Error creating purchase: #{e.message}"
            raise ActiveRecord::Rollback # Roll back the transaction due to errors
          end
        end
      end

      if errors.empty?
        head :no_content
      else
        render json: { errors: errors }, status: :unprocessable_entity
        raise ActiveRecord::Rollback # Roll back the transaction due to errors
      end
    end
  end

  def checkout
    gen_uuid = SecureRandom.uuid
    purchase_items = params[:purchase_items]
    errors = []
    purchase_items.each do |item|
      permitted_params = item.permit(:schedule_id, :student_id, :purchase_uuid, :gen_uuid, :product_id, :cart_type)
      permitted_params[:user_id] = current_user.id
      permitted_params[:purchase_uuid] = gen_uuid
      if permitted_params[:schedule_id].present?
        permitted_params[:cart_type] = 'cart_schedule'
        schedule = Schedule.find_by(id: permitted_params[:schedule_id])
        if schedule.nil?
          errors << "Schedule with ID #{permitted_params[:schedule_id]} not found."
          next
        end

        if schedule.currently_available == 0
          errors << "Schedule with ID #{permitted_params[:schedule_id]} is fully booked."
          next
        end

        purchase = Purchased.new(permitted_params)
        unless purchase.valid?
          errors << purchase.errors.full_messages.join(", ")
          next
        end
      else
        permitted_params[:cart_type] = 'cart_schedule'
        purchase = Purchase.new(item)

        unless purchase.valid?
          errors << purchase.errors.full_messages.join(", ")
          next
        end

        begin
          purchase.save!
        rescue StandardError => e
          errors << "Error creating purchase: #{e.message}"
          raise ActiveRecord::Rollback # Roll back the transaction due to errors
        end
      end
    end

    if errors.empty?
      head :no_content
    else
      render json: { errors: errors }, status: :unprocessable_entity
    end

  end

  def getStudentInfoSchedule
    begin
      student_ids = Purchased.where(schedule_id: params[:schedule_id]).pluck(:student_id)
      student_info = Student.where(id: student_ids)
      render json: student_info, include: [:user] 
    rescue StandardError => e
      render json: {error: "Failed to Fetch Student Info Schedule" , messge: e.message}, status: :unprocessable_entity
    end 
  end

  def getStudentInfoProduct
    begin
      student_ids = Purchased.where(product_id: params[:product_id]).pluck(:student_id)
      student_info = Student.where(id: student_ids)
      render json: student_info, include: [:user] 
    rescue StandardError => e
      render json: {error: "Failed to Fetch Student Info Product" , messge: e.message}, status: :unprocessable_entity
    end 
  end

end
