# frozen_string_literal: true

class SalelineItemsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create]
  skip_before_action :authenticate_user!, only: %i[create update destroy]

  def create
    product = Product.find(params[:id])
    if SalelineItem.create(title: product.title, price: product.price, quantity: 1,
                           product_id: product.id)
      session[:cart] << params[:id].to_i
    end
    redirect_to request.referer
  end

  def update
    saleline_item = SalelineItem.find(saleline_item_params['saleline_item_id'].to_i)
    saleline_item.update(quantity: saleline_item_params['quantity'].to_i)
    flash['notice'] = I18n.t('saleline_item.quantity_updated')
    redirect_to request.referer
  end

  def destroy
    session[:cart].delete(params[:id].to_i) if SalelineItem.find_by(product_id: params[:id]).destroy
    redirect_to request.referer
  end

  private

  def saleline_item_params
    params.require(:saleline_item).permit(:quantity, :saleline_item_id)
  end
end
