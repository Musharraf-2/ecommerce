# frozen_string_literal: true

class CartsController < ApplicationController
  def show
    @saleline_items = SalelineItem.where(product_id: session[:cart])
  end
end
