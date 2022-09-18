# frozen_string_literal: true

class CartsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[show]

  def show
    if user_signed_in?
      SalelineItem.map_products_to_signed_in_user(current_user.id)
      @saleline_items = SalelineItem.where(user_id: current_user.id)
    else
      @saleline_items = SalelineItem.where(product_id: session[:cart])
    end
  end
end
