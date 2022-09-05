class ProductsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  def index
    @products = Product.all
  end

  def show
    @product =  Product.find(params[:id])
  end

  def new
    @product = Product.new
  end

  def edit
    @product = Product.find(params[:id])
  end

  def create
    @product = Product.new(product_params)
    @product.user_id = current_user.id
    @product.serial_number = SecureRandom.uuid
    if @product.save
      redirect_to product_path(@product)
    else
      render 'new'
    end
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to product_path(@product)
    else
      render 'edit'
    end
  end

  def destroy
    @product = Product.find(params[:id]).destroy
    redirect_to dashboard_products_path
  end

  def dashboard
    @products = Product.where('user_id = ?', current_user.id)
  end

  private

  def product_params
    params.require(:product).permit(:title, :description, :price, :quantity)
  end
end
