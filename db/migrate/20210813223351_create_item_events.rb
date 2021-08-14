class CreateItemEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :item_events, id: :uuid do |t|
      t.references :item, null: false, type: :uuid
      t.string :event_type, null: false
      t.string :title, null: false
      t.string :url, null: false
      t.jsonb :data, default: {}, null: false

      t.timestamps
    end

    add_index :item_events, %i[created_at event_type], order: { created_at: :desc }
  end
end
