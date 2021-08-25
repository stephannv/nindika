class RenamePriceFields < ActiveRecord::Migration[6.1]
  def change
    rename_column(:prices, :regular_amount_cents, :base_price_cents)
    rename_column(:prices, :regular_amount_currency, :base_price_currency)
    rename_column(:prices, :discount_amount_cents, :discount_price_cents)
    rename_column(:prices, :discount_amount_currency, :discount_price_currency)
  end
end
