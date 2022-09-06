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
      flash.now[:notice] = 'Product creation failed.'
      render 'new'
    end
  end

  def update
    if @product.update(product_params)
      flash[:notice] = 'Product updated successfully.'
      redirect_to product_path(@product)
    else
      flash.now[:notice] = 'Product update failed.'
      render 'edit'
    end
  end

  def destroy
    @product.destroy
    redirect_to dashboard_products_path
  end

  def dashboard
    @products = current_user.products
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :quantity, images: [])
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
