class OrderedProduct < ApplicationRecord
  belongs_to :order, :product

  validates :quantity, :price, presence: true, numericlaity: true
end
