class Api::V1::CartsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_cart, only: [:show,:destroy,:update]
    def index
        begin
          carts = Cart.includes(:product, :schedule).where(user_id: current_user.id)
      
          carts_data = carts.as_json(include: {
            product: {},
            schedule: {
              include: {
                program: {},
                school: {}
              }
            }
          }).each do |cart_data|
            # Modify only the program's image_url for each cart's schedule
            program = cart_data.dig('schedule', 'program')
            if program
              program['image_url'] = cart_data['schedule']['program']['image'].attached? ? url_for(cart_data['schedule']['program']['image']) : program['image_url']
            end
          end
      
          render json: carts_data
        rescue StandardError => e
          render json: { error: "Failed to Fetch Carts", message: e.message }, status: :unprocessable_entity
        end
    end

    def create
        begin
          @carts_create = Cart.new(cart_params_post.merge(user_id: current_user.id))
          set_cart_type_based_on_params
          if @carts_create.save
            carts_data = @carts_create.as_json(include: {
              product: {},
              schedule: {
                include: {
                  program: {},
                  school: {}
                }
              }
            })
      
            # Modify only the program's image_url if an image is attached
            program = carts_data.dig('schedule', 'program')
            if program && @carts_create.schedule.program.image.attached?
              program['image_url'] = url_for(@carts_create.schedule.program.image)
            end
      
            render json: carts_data, status: :created
          else
            error_message = @carts_create.errors.full_messages.to_sentence
            render json: { error: error_message }, status: :unprocessable_entity
          end
        rescue StandardError => e
          render json: { error: "Failed to Create Cart", message: e.message }, status: :unprocessable_entity
        end
    end
    
    def update
        begin
            if @cart.update(cart_params)
                cart_data = @cart.as_json(include: {
                    product: {},
                    schedule: {
                    include: {
                        program: {},
                        school: {}
                    }
                    }
                })
            
                # Modify only the program's image_url if an image is attached
                program = cart_data.dig('schedule', 'program')
                if program && @cart.schedule.program.image.attached?
                    program['image_url'] = url_for(@cart.schedule.program.image)
                end
            
                render json: cart_data
            else
                error_message = @cart.errors.full_messages.to_sentence
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: { error: "Failed to Update Cart", message: e.message }, status: :unprocessable_entity
        end
    end
    

    def show
        render json: @cart, only: [:id, :title, :description, :is_active]
    end

    def destroy
        begin
            @cart.destroy
            head :no_content
        rescue StandardError => e
            render json: {error: "Failed to Delete Cart" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def clearCart
        begin
            Cart.where(user_id: current_user.id).delete_all
            head :no_content
        rescue StandardError => e
            render json: {error: "Failed to Clear Cart" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def getCartSummary
        begin
            product = Cart.includes(:product).where(cart_type: 'cart_product',user_id: current_user.id).sum(:price)
            schedule = Cart.includes(:schedule).where(cart_type: 'cart_schedule',user_id: current_user.id).sum(:price)
            render json: { product_sum: product, schedule_sum: schedule, total: product + schedule }
        rescue StandardError => e
            render json: {error: "Failed to Fetch Cart summary" , messge: e.message}, status: :unprocessable_entity
        end 
    end

    private
    def set_cart
        begin
            @cart = Cart.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { error: "Cart not found", message: e.message }, status: :not_found
        end
    end

    def cart_params_post
       params.permit(:schedule_id, :product_id, :student_id)
    end
    def set_cart_type_based_on_params
        if params[:product_id].present?
            @carts_create.cart_type = 'cart_product'
        elsif params[:schedule_id].present?
            @carts_create.cart_type = 'cart_schedule'
        end
      end
end
