# frozen_string_literal: true

class SalelineItem < ApplicationRecord
  validates :title, :price, :quantity, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 0 }
  validates :title, length: { in: 2..40 }

  scope :for_current_user, ->(user_id) { where(user_id: user_id) }

  def self.map_products_to_signed_in_user(user_id)
    saleline_items = SalelineItem.where.not(product_id: User.find(user_id).products.ids)
    saleline_items.each do |saleline_item|
      saleline_item.update(user_id: user_id)
    end
  end

  def self.calculate_total_amount(user_id)
    total_amount = 0
    saleline_items = SalelineItem.where(user_id: user_id)
    saleline_items.each do |saleline_item|
      total_amount += saleline_item.quantity * saleline_item.price
    end
    total_amount -= (total_amount * 0.1) unless Order.exists?(user_id: user_id)
    total_amount
  end

  def self.destroy_saleline_items_for_session(session)
    saleline_items = SalelineItem.where(product_id: session)
    saleline_items.each(&:destroy)
  end
end
