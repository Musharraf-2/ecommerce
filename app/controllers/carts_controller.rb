# frozen_string_literal: true

class CartsController < ApplicationController
  before_action :initialize_cart, :remove_signed_in_user_products, only: %i[show]

  def show
    @products = Product.find(session[:cart])
  end

  def update
    session[:cart] << params[:id].to_i
    redirect_to request.referer
  end

  def destroy
    session[:cart].delete(params[:id].to_i)
    redirect_to request.referer
  end

  private

  def initialize_cart
    session[:cart] ||= []
  end

  def remove_signed_in_user_products
    return unless user_signed_in?

    Product.where('user_id = ?', current_user.id).pluck(:id).each do |product_id|
      session[:cart].delete(product_id)
    end
  end
end
