# frozen_string_literal: true

class CreatePizzeriaMenus < ActiveRecord::Migration[6.0]
  def change
    create_table :pizzeria_menus, id: :uuid do |t|
      t.timestamps
    end

    add_reference :pizzeria_menus, :pizzeria_place, type: :uuid, index: true, foreign_key: true
    add_reference :pizzeria_menus, :pizza, type: :uuid, index: true, foreign_key: true
  end
end
