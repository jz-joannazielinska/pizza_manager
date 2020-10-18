# frozen_string_literal: true

class PizzeriaMenu < ApplicationRecord
    validates :pizzeria_place_id, uniqueness: { scope: :pizza_id }
end
