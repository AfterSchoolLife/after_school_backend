class Api::V1::SchoolsController < ApplicationController
    before_action :set_school, only: [:show,:destroy,:update]
  
    def index
        begin
            school = School.where(is_active: params[:isActive])
            render json: school, only: [:id, :name, :address, :is_active]
        rescue StandardError => e
            render json: {error: "Failed to Fetch Schools" , messge: e.message}, status: :unprocessable_entity
        end 
    end
    def create
        begin
            school = School.new(school_params)
            if school.save
                render json: school, status: :created
            else
                error_message = school.errors.full_messages.to_sentence
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Create School" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def update
        begin
            if @school.update(school_params)
                render json: @school, only: [:id, :name, :address,:is_active]
            else
                error_message = @school.errors.full_messages.to_sentence
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Update School" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def show
        render json: @school, only: [:id, :name, :address, :is_active]
    end

    def destroy
        begin
            @school.destroy
            head :no_content
        rescue StandardError => e
            render json: {error: "Failed to Delete School" , messge: e.message}, status: :unprocessable_entity
        end
    end

    private
    def set_school
        begin
            @school = School.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { error: "School not found", message: e.message }, status: :not_found
        end
    end

    def school_params
       params.permit(:name, :address, :is_active)
    end
end
