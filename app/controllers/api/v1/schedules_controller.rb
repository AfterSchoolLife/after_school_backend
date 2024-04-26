class Api::V1::SchedulesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :getAdminAll, :adminIndex]
  before_action :set_schedule, only: [:show,:destroy,:update]
  
  def index
    begin
      schedule = Schedule.where(school_id: params[:schoolId])
      render json: schedule
    rescue StandardError => e
      render json: {error: "Failed to Get schedule for school" , messge: e.message}, status: :unprocessable_entity
    end
  end

  def indexprivate
    begin
      schedule = Schedule.where(school_id: params[:schoolId],country: current_user.country)
      render json: schedule
    rescue StandardError => e
      render json: {error: "Failed to Get schedule for school" , messge: e.message}, status: :unprocessable_entity
    end
  end

  def adminIndex
    begin
        if current_user.role == 'super-admin'
          scheudle = Schedule.where(is_active: params[:isActive],country: current_user.country)
            render json: scheudle
        elsif current_user.role == 'admin'
          scheudle = Schedule.where(created_by: current_user.id, is_active: params[:isActive],country: current_user.country)
            render json: scheudle
        else
            render json: { error: 'You do not have access' }, status: :unprocessable_entity
        end
    rescue StandardError => e
        render json: {error: "Failed to Fetch Schedules" , messge: e.message}, status: :unprocessable_entity
    end 
  end

  def show
    render json: @schedule, each_serializer: ScheduleSerializer
  end

  def create
    begin
      schedule = Schedule.new(schedule_params.merge(currently_available: params[:total_available],created_by: current_user.id,country: current_user.country))
      if schedule.save
        render json: schedule, status: :created
      else
        render json: { error: schedule.errors.full_messages }, status: :unprocessable_entity
      end
    rescue StandardError => e
        render json: {error: "Failed to Create Schedule" , messge: e.message}, status: :unprocessable_entity
    end
  end

  def update
    begin
      if @schedule.update(schedule_params)
          render json: @schedule, serializer: ScheduleSerializer
      else
          error_message = @schedule.errors.full_messages.to_sentence
          render json: { error: error_message }, status: :unprocessable_entity
      end
    rescue StandardError => e
        render json: {error: "Failed to Update Schedule" , messge: e.message}, status: :unprocessable_entity
    end
  end

  def destroy
    begin
      @schedule.destroy
      head :no_content
    rescue StandardError => e
        render json: {error: "Failed to Delete Schedule" , messge: e.message}, status: :unprocessable_entity
    end
  end

  def getAdminAll
    begin
      if current_user.role == 'super-admin'
        school = School.where(is_active: true, country: current_user.country)
        programs = Program.where(is_active: true)
        render json: { schools: school, programs: programs }
      elsif current_user.role == 'admin'
        school = School.where(is_active: true, created_by: current_user.id, country: current_user.country)
        programs = Program.where(is_active: true, created_by: current_user.id)
        render json: { schools: school, programs: programs }
      else
        render json: { error: 'You do not have access' }, status: :unprocessable_entity
      end
    rescue StandardError => e
        render json: {error: "Failed to Get Schools and programs" , messge: e.message}, status: :unprocessable_entity
    end
  end

  def sendNotification
    begin
      
  end

  private
  def set_schedule
      begin
          @schedule = Schedule.find(params[:id])
      rescue ActiveRecord::RecordNotFound => e
          render json: { error: "Schedule not found", message: e.message }, status: :not_found
      end
  end
  def schedule_params
    params.permit(:days, :start_time, :end_time, :start_date, :end_date, :age_group, :price, :is_active, :school_id, :program_id, :teacher_name, :cost_of_teacher, :facility_rental, :total_available)
  end
end
