class Product < ApplicationRecord
  belongs_to :user

  validates :title, :description, :price, :quantity, :serial_number, presence: true
  validates :price, :quantity, numericality: true
  validates :title, length: { in: 2..40 }
  validates :description, length: { in: 5..500 }
  validates :serial_number, uniqueness: true
end
