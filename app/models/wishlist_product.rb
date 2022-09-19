# frozen_string_literal: true

class WishlistProduct < ApplicationRecord
  belongs_to :user
  belongs_to :product
end
