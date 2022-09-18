# frozen_string_literal: true

module ProductsHelper
  def get_product_quantity(product_id)
    Product.find(product_id).quantity.to_s
  end
end
