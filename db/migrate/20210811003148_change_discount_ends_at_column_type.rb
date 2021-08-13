class ChangeDiscountEndsAtColumnType < ActiveRecord::Migration[6.1]
  def change
    change_column :prices, :discount_ends_at, 'timestamp USING CAST(discount_ends_at AS timestamp)'
  end
end
