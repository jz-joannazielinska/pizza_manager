# frozen_string_literal: true

class Pizza < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :price, presence: true, inclusion: { in: 15..100.00 }
end
