class AddWithDemoToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :with_demo, :boolean, null: false, default: false
    remove_column :items, :demo_nsuid
    add_index :items, :with_demo, where: :with_demo
  end
end
