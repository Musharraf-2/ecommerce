# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :user
  has_many :ordered_products, dependent: :destroy

  validates :token, :amount, presence: true
  validates :paid_status, inclusion: { in: [true, false] }
  validates :amount, numericality: { greater_than: 0 }
end
