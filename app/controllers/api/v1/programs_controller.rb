class Api::V1::ProgramsController < ApplicationController
    before_action :authenticate_user!, only: [:adminIndex, :create]
    before_action :set_program, only: [:show,:destroy,:update]
    def index
        begin
            programs = Program.where(is_active: true)
            render json: programs, only: [:id, :title, :image_url, :description, :is_active]
        rescue StandardError => e
            render json: {error: "Failed to Fetch Programs" , messge: e.message}, status: :unprocessable_entity
        end 
    end
    def adminIndex
        begin
            if current_user.role == 'super-admin'
                programs = Program.where(is_active: params[:isActive])
                render json: programs
            elsif current_user.role == 'admin'
                programs = Program.where(created_by: current_user.id, is_active: params[:isActive])
                render json: programs
            else
                render json: { error: 'You do not have access' }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Fetch Programs" , messge: e.message}, status: :unprocessable_entity
        end 
    end
    def create
        begin
            program = Program.new(program_params.merge(created_by: current_user.id))
            if program.save
                render json: program, status: :created
            else
                error_message = program.errors.full_messages.to_sentence
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Create Program" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def update
        begin
            if @program.update(program_params)
                render json: @program
            else
                error_message = @program.errors.full_messages.to_sentence
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Update Program" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def show
        render json: @program, only: [:id, :title, :image_url, :description, :is_active]
    end

    def destroy
        begin
            @program.destroy
            head :no_content
        rescue StandardError => e
            render json: {error: "Failed to Delete Program" , messge: e.message}, status: :unprocessable_entity
        end
    end

    private
    def set_program
        begin
            @program = Program.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { error: "Program not found", message: e.message }, status: :not_found
        end
    end

    def program_params
       params.permit(:title, :image_url, :description, :is_active)
    end
end