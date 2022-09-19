# frozen_string_literal: true

module ProductsHelper
  def get_product_quantity(product_id)
    Product.find(product_id).quantity.to_s
  end

  def show_product_buy_button(current_user, product, session)
    return unless (user_signed_in? && current_user.id != product.user_id) || !user_signed_in?

    if product.quantity.positive?
      check_for_product_in_cart(session, product)
    else
      '<p class="text-danger m-2">Currently out of stock.</p>'.html_safe
    end
  end

  def show_wishlist_button(current_user, product)
    return unless user_signed_in? && current_user.id != product.user_id

    if wishlist_products_exists(product.id, current_user.id)
      '<p class="text-success m-2 wishlist-text">This product is in your wishlist.</p>'.html_safe
    else
      button_to 'Add to Wishlist', wishlist_path(id: product.id), method: :put, remote: 'true', class: 'btn-secondary
      p-2 rounded mx-2'
    end
  end

  def check_for_product_in_cart(session, product)
    if session.include? product.id
      button_to 'Remove from Cart', saleline_item_path(id: product.id), method: :delete, class: 'btn-danger p-2
      rounded mx-2'
    else
      button_to 'Add to Cart', saleline_item_path(id: product.id), method: :create, class: 'btn-primary p-2 rounded
        mx-2'
    end
  end
end
