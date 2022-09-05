class OrderedProduct < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, :price, presence: true, numericlaity: true
end
