class AddScreenshotUrlsToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :screenshot_urls, :string, array: true, null: false, default: []
  end
end
