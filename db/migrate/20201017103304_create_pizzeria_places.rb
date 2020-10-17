# frozen_string_literal: true

class CreatePizzeriaPlaces < ActiveRecord::Migration[6.0]
  def change
    create_table :pizzeria_places, id: :uuid do |t|
      t.string :name, null: false, unique: true
      t.string :address, null: false
      t.time :opens_at, null: false
      t.time :closes_at, null: false
      t.timestamps
    end
  end
end
