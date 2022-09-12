# frozen_string_literal: true

class SalelineItem < ApplicationRecord
  validates :title, :price, :quantity, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than: 0 }
  validates :title, length: { in: 2..40 }
end
