class RenameItemsToGames < ActiveRecord::Migration[7.0]
  def change
    rename_table :items, :games
    rename_column :raw_items, :item_id, :game_id
    rename_column :prices, :item_id, :game_id
    rename_column :item_events, :item_id, :game_id
    rename_column :wishlist_items, :item_id, :game_id
    rename_column :hidden_items, :item_id, :game_id
    rename_column :event_dispatches, :item_event_id, :game_event_id
    rename_table :hidden_items, :hidden_games
    rename_table :item_events, :game_events
    rename_table :wishlist_items, :wishlist_games
  end
end
