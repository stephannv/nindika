class AdjustItemsColumns < ActiveRecord::Migration[7.0]
  def change
    change_table :items, bulk: true do |t|
      t.column :bg_color, :string
      t.column :headline, :string
      t.column :video_urls, :string, default: [], null: false, array: true
    end

    rename_column :items, :bytesize, :rom_size
  end
end
