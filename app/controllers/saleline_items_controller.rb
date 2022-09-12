# frozen_string_literal: true

class SalelineItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]

  def create
    product = Product.find(params[:id])
    session[:cart] << params[:id].to_i
    SalelineItem.create(title: product.title, price: product.price, quantity: 1,
                        product_id: product.id)
    redirect_to request.referer
  end

  def update
    s = SalelineItem.find(saleline_item_params['saleline_item_id'].to_i)
    s.update(quantity: saleline_item_params['quantity'].to_i)
    flash['notice'] = 'Quantity updated successfully.'
    redirect_to request.referer
  end

  def destroy
    session[:cart].delete(params[:id].to_i)
    SalelineItem.find_by(product_id: params[:id]).destroy
    redirect_to request.referer
  end

  private

  def saleline_item_params
    params.require(:saleline_item).permit(:quantity, :saleline_item_id)
  end
end
