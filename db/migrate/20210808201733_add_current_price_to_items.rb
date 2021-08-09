class AddCurrentPriceToItems < ActiveRecord::Migration[6.1]
  def change
    add_monetize :items, :current_price, amount: { null: true, default: nil }
  end
end
