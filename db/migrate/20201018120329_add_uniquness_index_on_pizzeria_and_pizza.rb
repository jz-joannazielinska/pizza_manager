class AddUniqunessIndexOnPizzeriaAndPizza < ActiveRecord::Migration[6.0]
  def change
    add_index :pizzeria_menus, [:pizzeria_place_id, :pizza_id], unique: true
  end
end
