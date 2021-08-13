class DropNotifications < ActiveRecord::Migration[6.1]
  def change
    drop_table :notifications
  end
end
