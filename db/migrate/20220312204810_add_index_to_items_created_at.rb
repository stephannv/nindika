class AddIndexToItemsCreatedAt < ActiveRecord::Migration[7.0]
  disable_ddl_transaction!

  def change
    add_index :items, :created_at, order: { created_at: :desc }, algorithm: :concurrently
  end
end
