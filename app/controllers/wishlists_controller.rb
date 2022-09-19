# frozen_string_literal: true

class WishlistsController < ApplicationController
  before_action :find_wishlist_product, only: %i[update destroy]

  def show
    @wishlist_products = Product.find(current_user.wishlist_products.pluck(:product_id))
  end

  def update
    WishlistProduct.create(user_id: current_user.id, product_id: params[:id]) unless @wishlist_product
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
