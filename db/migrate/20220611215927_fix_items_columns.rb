# frozen_string_literal: true

class FixItemsColumns < ActiveRecord::Migration[7.0]
  def change
    change_table :items, bulk: true do |t|
      t.remove :boxart_url, :content_rating, :extra, :publishers, :developers

      t.change :banner_url, :string, limit: nil
      t.change :website_url, :string, limit: nil

      t.column :developer, :string
      t.column :publisher, :string
      t.column :demo_nsuid, :string
      t.column :num_of_players, :string
      t.column :item_type, :integer, null: false, index: true
    end
  end
end
