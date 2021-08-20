class AddIndexToItemGenres < ActiveRecord::Migration[6.1]
  def change
    add_index :items, :genres, using: 'gin'
  end
end
