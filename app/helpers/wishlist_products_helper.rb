# frozen_string_literal: true

module WishlistProductsHelper
  def wishlist_products_exists(product_id, user_id)
    WishlistProduct.exists?(user_id: user_id, product_id: product_id)
  end
end
