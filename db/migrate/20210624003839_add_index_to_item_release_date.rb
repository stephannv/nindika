class AddIndexToItemReleaseDate < ActiveRecord::Migration[6.1]
  def change
    add_index :items, :release_date
  end
end
