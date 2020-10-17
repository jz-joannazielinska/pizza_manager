# frozen_string_literal: true

FactoryBot.define do
  factory :pizza do
    name { Faker::Food.dish }
    price { 20.00 }
    ingridients { Faker::Food.ingredient }
  end
end
