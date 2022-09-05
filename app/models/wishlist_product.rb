class WishlistProduct < ApplicationRecord
  belongs_to :user, :product
end
