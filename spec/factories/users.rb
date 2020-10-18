# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    id { SecureRandom.uuid }
    password { Faker::Internet.password }
    password_confirmation { |u| u.password }
    email { Faker::Internet.email }
  end
end
