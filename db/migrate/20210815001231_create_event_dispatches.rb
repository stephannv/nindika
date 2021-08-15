class CreateEventDispatches < ActiveRecord::Migration[6.1]
  def change
    create_table :event_dispatches, id: :uuid do |t|
      t.references :item_event, null: false, foreign_key: true, type: :uuid
      t.string :provider, null: false
      t.string :sent_at

      t.timestamps
    end

    add_index :event_dispatches, %i[item_event_id provider], unique: true
    add_index :event_dispatches,
      %i[item_event_id provider sent_at],
      name: 'idx_event_provider_sent_at',
      where: 'sent_at IS NULL'
  end
end
