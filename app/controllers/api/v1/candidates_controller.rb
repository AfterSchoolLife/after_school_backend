class Api::V1::CandidatesController < ApplicationController
  before_action :set_candidate, only: [:destroy]
  def index
    begin
        candidates = Candidate.all
        render json: candidates
    rescue StandardError => e
        render json: {error: "Failed to Fetch Candidates" , messge: e.message}, status: :unprocessable_entity
    end 
  end
  def create
    begin
        candidate = Candidate.new(candidate_params)
        if candidate.save
            render json: candidate, status: :created
        else
            error_message = candidate.errors.full_messages.to_sentence
            render json: { error: error_message }, status: :unprocessable_entity
        end
    rescue StandardError => e
        render json: {error: "Failed to Create Candidate" , messge: e.message}, status: :unprocessable_entity
    end
  end  

  def destroy
    begin
      @candidate.destroy
      head :no_content
    rescue StandardError => e
      render json: {error: "Failed to Delete Candidate" , messge: e.message}, status: :unprocessable_entity
    end
  end
  private
    def set_candidate
        begin
            @candidate = Candidate.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { error: "Candidate not found", message: e.message }, status: :not_found
        end
    end
    def candidate_params
      params.permit(:firstname, :lastname, :email, :phonenumber, :about, :skills)
   end
end
