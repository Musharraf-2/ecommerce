# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
3.times do
  user = User.new(email: Faker::Internet.unique.email, password: '123456')
  user.image.attach(io: File.open(Rails.root.join('app/assets/images/user.jpeg')),
                    filename: 'user.jepg')
  user.save
end

3.times do
  product = Product.new(title: Faker::Commerce.unique.product_name, price: Faker::Commerce.unique.price,
                        description: Faker::Lorem.unique.sentence, quantity: Faker::Number.unique.number(digits: 3),
                        user_id: 1, serial_number: Faker::Crypto.unique.md5)
  product.images.attach(io: File.open(Rails.root.join('app/assets/images/car.jpeg')), filename: 'car.jepg')
  product.save
end

3.times do
  product = Product.new(title: Faker::Commerce.unique.product_name, price: Faker::Commerce.unique.price,
                        description: Faker::Lorem.unique.sentence, quantity: Faker::Number.unique.number(digits: 3),
                        user_id: 2, serial_number: Faker::Crypto.unique.md5)
  product.images.attach(io: File.open(Rails.root.join('app/assets/images/car.jpeg')), filename: 'car.jepg')
  product.save
end
