class CreateItemRelationship < ActiveRecord::Migration[7.0]
  def change
    create_table :item_relationships, id: :uuid do |t|
      t.references :parent, null: false, foreign_key: { to_table: :items }, type: :uuid
      t.references :child, null: false, foreign_key: { to_table: :items }, type: :uuid

      t.timestamps
    end

    add_index :item_relationships, %i[parent_id child_id], unique: true
  end
end
