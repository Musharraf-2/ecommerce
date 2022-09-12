# frozen_string_literal: true

class SalelineItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]
  before_action :set_product, only: %i[create]
  before_action :add_product_in_session, only: %i[create]
  before_action :delete_product_from_session, only: %i[destroy]

  def create
    SalelineItem.create(title: @product.title, price: @product.price, quantity: 1,
                        product_id: @product.id)
    redirect_to request.referer
  end

  def update
    s = SalelineItem.find(saleline_item_params['saleline_item_id'].to_i)
    s.update(quantity: saleline_item_params['quantity'].to_i)
    flash['notice'] = 'Quantity updated successfully.'
    redirect_to request.referer
  end

  def destroy
    SalelineItem.find_by(product_id: params[:id]).destroy
    redirect_to request.referer
  end

  private

  def saleline_item_params
    params.require(:saleline_item).permit(:quantity, :saleline_item_id)
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def add_product_in_session
    session[:cart] << params[:id].to_i
  end

  def delete_product_from_session
    session[:cart].delete(params[:id].to_i)
  end
end
