class DropEventRelatedTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :event_dispatches
    drop_table :item_events
  end
end
