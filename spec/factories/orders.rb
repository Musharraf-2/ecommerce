# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    paid_status { Faker::Boolean.boolean }
    token { Faker::Crypto.md5 }
    amount { Faker::Number.number(digits: 5) }
    user
  end
end
