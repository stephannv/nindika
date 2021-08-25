class AddNewFieldsToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :languages, :string, array: true, null: false, default: []
    add_column :items, :bytesize, :integer, limit: 8
    add_column :items, :last_scraped_at, :datetime
    add_index :items, :languages, using: 'gin'
    add_index :items, :last_scraped_at
  end
end
