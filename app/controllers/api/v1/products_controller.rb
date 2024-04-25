class Api::V1::ProductsController < ApplicationController
    before_action :authenticate_user!, only: [:create, :adminIndex]
    before_action :set_product, only: [:show,:destroy,:update]
    def index
        begin
            products = Product.where(is_active: params[:isActive])
            render json: products, only: [:id, :title, :description, :is_active, :price, :image_url]
        rescue StandardError => e
            render json: {error: "Failed to Fetch Product" , messge: e.message}, status: :unprocessable_entity
        end 
    end
    def adminIndex
        begin
            if current_user.role == 'super-admin'
                products = Product.where(is_active: params[:isActive])
                render json: products
            elsif current_user.role == 'admin'
                products = Product.where(created_by: current_user.id, is_active: params[:isActive])
                render json: products
            else
                render json: { error: 'You do not have access' }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Fetch Products" , messge: e.message}, status: :unprocessable_entity
        end 
    end
    def create
        begin
            product = Product.new(product_params.merge(created_by: current_user.id))
            if product.save
                render json: product, status: :created
            else
                error_message = product.errors.full_messages.to_sentence
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Create Product" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def update
        begin
            if @product.update(product_params)
                render json: @product
            else
                error_message = @product.errors.full_messages.to_sentence
                render json: { error: error_message }, status: :unprocessable_entity
            end
        rescue StandardError => e
            render json: {error: "Failed to Update Product" , messge: e.message}, status: :unprocessable_entity
        end
    end

    def show
        render json: @product, only: [:id, :title, :description, :is_active, :price, :image_url]
    end

    def destroy
        begin
            @product.destroy
            head :no_content
        rescue StandardError => e
            render json: {error: "Failed to Delete Product" , messge: e.message}, status: :unprocessable_entity
        end
    end

    private
    def set_product
        begin
            @product = Product.find(params[:id])
        rescue ActiveRecord::RecordNotFound => e
            render json: { error: "Product not found", message: e.message }, status: :not_found
        end
    end

    def product_params
       params.permit(:title, :description, :is_active, :price, :image_url)
    end
end

