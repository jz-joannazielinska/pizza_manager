# frozen_string_literal: true

class CreatePizzas < ActiveRecord::Migration[6.0]
  def change
    create_table :pizzas, id: :uuid do |t|
      t.string :name, null: false, unique: true
      t.decimal :price, null: false, precision: 8, scale: 2
      t.text :ingridients, null: false
      t.timestamps
    end
  end
end
