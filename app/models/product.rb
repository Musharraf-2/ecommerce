# frozen_string_literal: true

class Product < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  has_many :comments, dependent: :destroy

  validates :title, :description, :price, :quantity, :serial_number, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :title, length: { in: 2..40 }
  validates :description, length: { in: 5..500 }
  validates :serial_number, uniqueness: true
  validates :images, attached: true, content_type: ['image/png', 'image/jpeg']

  before_validation :generate_unique_serial_number

  scope :search, ->(title) { where('title ILIKE ?', "%#{title.strip.squeeze(' ')}%") }

  def self.all_products(query)
    if query.blank?
      Product.all
    else
      Product.search(query)
    end
  end

  private

  def generate_unique_serial_number
    self.serial_number = SecureRandom.uuid
  end
end
