# frozen_string_literal: true

FactoryBot.define do
  factory :ordered_product do
    title { Faker::Commerce.product_name }
    price { Faker::Number.between(from: 1, to: 99_999) }
    quantity { Faker::Number.between(from: 1, to: 500) }
    order
  end
end
