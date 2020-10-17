# frozen_string_literal: true

class AddUserToPizzeriaPlace < ActiveRecord::Migration[6.0]
  def change
    add_reference :pizzeria_places, :user, type: :uuid, index: true, foreign_key: true
  end
end
