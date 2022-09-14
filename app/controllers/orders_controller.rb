# frozen_string_literal: true

class OrdersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[create capture_order]
  before_action :paypal_init, only: %i[create capture_order]
  before_action :authenticate_user!, only: %i[show create capture_order]
  after_action :save_ordered_products, :send_email_to_seller, only: %i[capture_order]

  def show
    @saleline_items = SalelineItem.map_products_to_signed_in_user(current_user.id)
    @total_amount = SalelineItem.calculate_total_amount(current_user.id)
  end

  def create
    total_amount = SalelineItem.calculate_total_amount(current_user.id)
    request = PayPalCheckoutSdk::Orders::OrdersCreateRequest.new
    request.request_body({
                           intent: 'CAPTURE',
                           purchase_units: [
                             {
                               amount: {
                                 currency_code: 'USD',
                                 value: total_amount.to_s
                               }
                             }
                           ]
                         })
    response = @client.execute request
    order = Order.new(user_id: current_user.id, amount: total_amount, token: response.result.id)
    render json: { token: response.result.id }, status: :ok if order.save
  end

  def capture_order
    request = PayPalCheckoutSdk::Orders::OrdersCaptureRequest.new params[:order_id]
    response = @client.execute request
    order = Order.find_by token: params[:order_id]
    order.paid_status = response.result.status == 'COMPLETED'
    render json: { status: response.result.status }, status: :ok if order.save
  end

  private

  def paypal_init
    client_id = 'AR-LlsQt-nlCNqvmOJM7AueCpe9pkyoSZyEyN_oWIcEj-ItW6SwWinPbTVlHJIdK1oMsQokIalY6cOOJ'
    client_secret = 'ECH3xnOhcoMY1C9C_KCy2TRbdolETVUjntO9WEq2_YCXZAkeOqYAA7zErKNlaxWAbCGGaG4FqCkOsVfP'
    environment = PayPal::SandboxEnvironment.new client_id, client_secret
    @client = PayPal::PayPalHttpClient.new environment
  end

  def save_ordered_products
    order = Order.find_by(token: params[:order_id])
    saleline_items = SalelineItem.where(user_id: current_user.id)
    saleline_items.each do |saleline_item|
      order.ordered_products.create(title: saleline_item.title, quantity: saleline_item.quantity,
                                    price: saleline_item.price)
      saleline_items.each(&:destroy)
    end
    session.delete(:cart)
  end

  def send_email_to_seller
    user_ids = Product.sellers_for_mail(current_user.id).pluck(:user_id)
    users = User.where(id: user_ids)
    sold_products = SalelineItem.for_current_user(current_user.id).pluck(:title, :quantity, :price)
    users.each do |user|
      UserMailer.with(email: user.email, ordered_products: sold_products).sold_product_email.deliver_later
    end
  end
end
