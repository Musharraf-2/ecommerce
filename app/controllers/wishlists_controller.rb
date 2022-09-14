# frozen_string_literal: true

class WishlistsController < ApplicationController
  before_action :authenticate_user!, only: %i[show update destroy]
  before_action :find_wishlist_product, only: %i[update destroy]

  def show
    @products = Product.find(current_user.wishlist_products.pluck(:product_id))
  end

  def update
    if !@wishlist_product
      WishlistProduct.create(user_id: current_user.id, product_id: params[:id])
      flash[:notice] = 'Product added to wishlist.'
    else
      flash[:alert] = 'Product already in wishlist.'
    end
    redirect_to request.referer
  end

  def destroy
    @wishlist_product.destroy
    redirect_to request.referer
  end

  private

  def find_wishlist_product
    @wishlist_product = WishlistProduct.find_by(user_id: current_user.id, product_id: params[:id])
  end
end
