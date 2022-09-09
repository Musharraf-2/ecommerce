# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    @products = Product.find(session[:cart])
  end

  def add_to_cart
    session[:cart] << convert_to_int(params[:id])
    redirect_to request.referer
  end

  def remove_from_cart
    session[:cart].delete(convert_to_int(params[:id]))
    redirect_to request.referer
  end

  private

  def convert_to_int(product_id)
    product_id.to_i
  end
end
