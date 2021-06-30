class AddDiscountedAmountToPrices < ActiveRecord::Migration[6.1]
  def change
    add_monetize :prices, :discounted_amount, amount: { null: true, default: nil }
  end
end
