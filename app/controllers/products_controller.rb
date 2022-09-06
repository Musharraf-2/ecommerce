# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all
  end

  def show; end

  def new
    @product = Product.new
  end

  def edit; end

  def create
    @product = current_user.products.new(product_params)
    if @product.save
      flash[:notice] = 'Product created successfully.'
      redirect_to product_path(@product)
    else
      flash[:notice] = 'Product creation failed.'
      render 'new'
    end
  end

  def update
    if @product.update(product_params)
      flash[:notice] = 'Product updated successfully.'
      redirect_to product_path(@product)
    else
      flash[:notice] = 'Product update failed.'
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to dashboard_products_path
  end

  def dashboard
    @products = Product.for_current_user(current_user.id)
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :quantity, images: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
