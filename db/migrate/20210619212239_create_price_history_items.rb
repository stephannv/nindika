class CreatePriceHistoryItems < ActiveRecord::Migration[6.1]
  def change
    create_table :price_history_items, id: :uuid do |t|
      t.references :price, null: false, foreign_key: true, type: :uuid
      t.date :reference_date, null: false
      t.monetize :amount

      t.timestamps
    end

    add_index :price_history_items, %i[price_id reference_date], unique: true
  end
end
