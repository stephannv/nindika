class DropItemFlagColumns < ActiveRecord::Migration[6.1]
  def change
    remove_column :items, :on_sale, :boolean, default: false, null: false
    remove_column :items, :new_release, :boolean, default: false, null: false
    remove_column :items, :coming_soon, :boolean, default: false, null: false
    remove_column :items, :pre_order, :boolean, default: false, null: false

    remove_index :items, :last_week_visits
    remove_index :items, :all_time_visits
  end
end
