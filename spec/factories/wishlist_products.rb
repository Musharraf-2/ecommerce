# frozen_string_literal: true

FactoryBot.define do
  factory :wishlist_product do
    product
    user
  end
end
