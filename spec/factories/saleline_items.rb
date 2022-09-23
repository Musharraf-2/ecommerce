# frozen_string_literal: true

FactoryBot.define do
  factory :saleline_item do
    title { Faker::Commerce.product_name }
    price { Faker::Number.between(from: 1, to: 99_999) }
    quantity { Faker::Number.between(from: 1, to: 500) }
    user_id { Faker::Number.number(digits: 6) }
    product_id { Faker::Number.number(digits: 6) }
  end
end
