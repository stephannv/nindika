class AddIndexToItemsSlug < ActiveRecord::Migration[7.0]
  def change
    add_index :items, :slug
  end
end
