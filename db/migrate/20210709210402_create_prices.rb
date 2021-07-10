class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices, id: :uuid do |t|
      t.references :item, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :country_code, null: false, limit: 2
      t.string :nsuid, null: false, limit: 32, index: { unique: true }
      t.monetize :base_price
      t.monetize :discount_price, amount: { null: true, default: nil }
      t.datetime :discount_started_at
      t.datetime :discount_ends_at
      t.string :state, null: false
      t.integer :gold_points

      t.timestamps
    end
  end
end
