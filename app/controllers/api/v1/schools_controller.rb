class Api::V1::SchoolsController < ApplicationController
    before_action :authenticate_user!, only: [:adminIndex, :create, :indexprivate]
    before_action :set_school, only: [:show,:destroy,:update]
  
    def index
        begin
            school = School.where(is_active: true)
            render json: school, only: [:id, :name, :address, :is_active]
        rescue StandardError => e
            render json: {error: "Failed to Fetch Schools" , messge: e.message}, status: :unprocessable_entity
        end 
    end
    def indexprivate
        begin
            school = School.where(is_active: true,country: current_user.country)
            render json: school, only: [:id, :name, :address, :is_active]
        rescue StandardError => e
            render json: {error: "Failed to Fetch Schools" , messge: e.message}, status: :unprocessable_entity
        end 
    end
    def adminIndex
        begin
            if current_user.role == 'super-admin'
                schools = School.where(is_active: params[:isActive], country: current_user.country)
                render json: schools
            elsif current_user.role == 'admin'
                schools = School.where(created_by: current_user.id, is_active: params[:isActive], country: current_user.country)
                render json: schools
            else
                render json: { error: 'You do not have access' }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Fetch Schools" , messge: e.message}, status: :unprocessable_entity
        end 
    end
    def create
        begin
            school = School.new(school_params.merge(country: current_user.country))
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
