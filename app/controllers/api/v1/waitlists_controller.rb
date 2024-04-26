class Api::V1::WaitlistsController < ApplicationController
    before_action :authenticate_user!
  
    def create
        purchased = Purchased.find_by(user: current_user.id, schedule_id: params[:schedule_id], student_id: params[:student_id])
        if purchased
            render json: { errors: ['Program Already Purchased'] }, status: :unprocessable_entity
        else
            waitlist = Waitlist.new(waitlist_params.merge(user_id: current_user.id))
            if waitlist.save
                render json: waitlist, status: :created
            else
                render json: { errors: waitlist.errors.full_messages }, status: :unprocessable_entity
            end
        end
    end
  
    def index
        begin
            waitlist = Waitlist.all
            render json: waitlist
        rescue StandardError => e
            render json: {error: "Failed to Fetch Waitlist" , messge: e.message}, status: :unprocessable_entity
        end 
      end
    
    private

    def waitlist_params
      params.permit(:schedule_id, :student_id)
    end
end
  
