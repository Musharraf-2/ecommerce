# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    price { Faker::Number.between(from: 1, to: 99_999) }
    quantity { Faker::Number.between(from: 0, to: 500) }
    serial_number { Faker::Crypto.md5 }
    images do
      [Rack::Test::UploadedFile.new('app/assets/images/car.jpeg', 'product.jpeg'),
       Rack::Test::UploadedFile.new('app/assets/images/car.png', 'product.png')]
    end
    user
  end
end
