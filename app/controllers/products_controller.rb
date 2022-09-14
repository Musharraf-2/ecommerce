# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_product, only: %i[show edit update destroy]
  before_action :initialize_cart, only: %i[index show]

  def index
    @products = Product.all_products(params[:query]).page(params[:page]).per(6)
  end

  def show
    @comment = Comment.new
  end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      flash[:notice] = 'Product created successfully.'
      redirect_to dashboard_products_path
    else
      flash.now[:alert] = 'Product creation failed.'
      render 'new'
    end
  end

  def update
    @old_price = @product.price
    if @product.update(product_params)
      flash[:notice] = 'Product updated successfully.'
      @product.send_emails(@old_price)
      redirect_to dashboard_products_path
    else
      flash.now[:alert] = 'Product update failed.'
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    session[:cart].delete((params[:id].to_i))
    redirect_to dashboard_products_path
  end

  def dashboard
    @products = current_user.products.page(params[:page]).per(6)
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :quantity, images: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def initialize_cart
    session[:cart] ||= []
  end
end
