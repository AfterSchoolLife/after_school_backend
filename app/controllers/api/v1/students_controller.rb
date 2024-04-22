class Api::V1::StudentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_student, only: [:show,:destroy,:update]
    def index
        begin
            students = Student.where(is_active: params[:isActive], user_id: current_user.id)
            render json: students, only: [:id, :firstname, :lastname, :age, :grade,:pickup, :address, :city, :state, :zip]
        rescue StandardError => e
            render json: {error: "Failed to Fetch Students" , messge: e.message}, status: :unprocessable_entity
        end 
    end
    def create
        begin
            student = Student.new(student_params_create.merge(user_id: current_user.id))
            if student.save
                render json: student, status: :created
            else
                error_message = student.errors.full_messages.to_sentence
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Create Student" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def update
        begin
            if @student.update(student_params)
                render json: @student
            else
                error_message = @student.errors.full_messages.to_sentence
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Update Student" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def show
        render json: @student, only: [:firstname, :lastname, :age, :grade, :pickup, :address, :city, :state, :zip, :is_active]
    end

    def destroy
        begin
            @student.destroy
            head :no_content
        rescue StandardError => e
            render json: {error: "Failed to Delete Student" , messge: e.message}, status: :unprocessable_entity
        end
    end

    private
    def set_student
        begin
            @student = Student.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { error: "Student not found", message: e.message }, status: :not_found
        end
    end

    def student_params_create
        params.permit(:firstname, :lastname, :age, :grade, :pickup, :address, :city, :state, :zip, :user_id,:is_active)
    end
    def student_params
        params.permit(:firstname, :lastname, :age, :grade, :pickup, :address, :city, :state, :zip, :is_active)
    end
end
