# frozen_string_literal: true

class UserMailer < ApplicationMailer
  before_action :set_email

  def price_changed_email
    @old_price = params[:old_price]
    @product = params[:product]
    attachments['product.jpeg'] = @product.images[0].download
    mail(to: @email, subject: 'Price changed for a product in your wishlist!')
  end

  def sold_product_email
    @email = params[:email]
    @ordered_products = params[:ordered_products]
    mail(to: @email, subject: "#{@email} bought a product from your catalouge!")
  end

  private

  def set_email
    @email = params[:email]
  end
end
