# frozen_string_literal: true

FactoryBot.define do
  factory :pizzeria_place do
    id { SecureRandom.uuid }
    name { Faker::Restaurant.name }
    address { Faker::Restaurant.name }
    opens_at { Time.parse('10:00') }
    closes_at { Time.parse('22:00') }
    user_id { SecureRandom.uuid }
  end
end
