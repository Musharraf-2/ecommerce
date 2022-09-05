class Product < ApplicationRecord
  has_many :comments
  belongs_to :user

  validates :name, :description, :price, :quantity, :serial_number, presence: true
  validates :price, :quantity, numericality:true
  validates :name, length {in 2..40}
  validates :description, length {in 5..500}
end
