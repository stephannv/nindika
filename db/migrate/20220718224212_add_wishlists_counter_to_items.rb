class AddWishlistsCounterToItems < ActiveRecord::Migration[7.0]
  def change
    add_column :items, :wishlists_count, :integer, null: false, default: 0

    add_index :items, :wishlists_count, order: { wishlists_count: :desc }
  end
end
