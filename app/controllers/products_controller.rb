# frozen_string_literal: true

class ProductsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_product, only: %i[show edit update destroy]
  before_action :authorize_product, only: %i[edit update destroy]
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
      redirect_to dashboard_products_path, notice: I18n.t('product.created')
    else
      render :new, alert: I18n.t('product.creation_failed')
    end
  end

  def update
    @old_price = @product.price
    if @product.update(product_params)
      @product.send_emails(@old_price)
      redirect_to dashboard_products_path, notice: I18n.t('product.update')
    else
      render :edit, alert: I18n.t('product.update_failed')
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

  def authorize_product
    authorize @product
  end
end
