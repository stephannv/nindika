class CreateHiddenItems < ActiveRecord::Migration[6.1]
  def change
    create_table :hidden_items, id: :uuid do |t|
      t.references :user, null: false, foreign_key: true, type: :uuid
      t.references :item, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end

    add_index :hidden_items, %i[user_id item_id], unique: true
  end
end
