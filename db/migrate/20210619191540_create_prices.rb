class CreatePrices < ActiveRecord::Migration[6.1]
  def change
    create_table :prices, id: :uuid do |t|
      t.references :item, null: false, foreign_key: true, type: :uuid, index: { unique: true }
      t.string :nsuid, null: false
      t.monetize :regular_amount
      t.monetize :discount_amount, amount: { null: true, default: nil }
      t.datetime :discount_started_at
      t.string :discount_ends_at
      t.integer :discount_percentage
      t.string :state, null: false
      t.integer :gold_points

      t.timestamps
    end

    add_index :prices, :nsuid, unique: true
  end
end
