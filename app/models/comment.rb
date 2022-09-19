# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :body, presence: true, length: { in: 5..500 }
end
