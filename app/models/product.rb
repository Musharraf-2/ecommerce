class Product < ApplicationRecord
  belongs_to :user
  has_many_attached :images

  validates :title, :description, :price, :quantity, :serial_number, presence: true
  validates :price, :quantity, numericality: true
  validates :title, length: { in: 2..40 }
  validates :description, length: { in: 5..500 }
  validates :serial_number, uniqueness: true
  validates :images, attached: true, content_type: ['image/png', 'image/jpeg']
end
