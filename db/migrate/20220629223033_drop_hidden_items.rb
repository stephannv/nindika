class DropHiddenItems < ActiveRecord::Migration[7.0]
  def change
    drop_table :hidden_items, if_exists: true
  end
end
