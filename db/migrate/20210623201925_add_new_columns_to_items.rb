class AddNewColumnsToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :on_sale, :boolean, default: false, null: false
    add_column :items, :new_release, :boolean, default: false, null: false
    add_column :items, :coming_soon, :boolean, default: false, null: false
    add_column :items, :pre_order, :boolean, default: false, null: false

    add_index :items, :on_sale, where: :on_sale
    add_index :items, :new_release, where: :new_release
    add_index :items, :coming_soon, where: :coming_soon
    add_index :items, :pre_order, where: :pre_order
  end
end
