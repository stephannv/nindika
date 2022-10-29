class ChangeItemTypeColumnType < ActiveRecord::Migration[7.0]
  def change
    change_column(:items, :item_type, :string)
  end
end
