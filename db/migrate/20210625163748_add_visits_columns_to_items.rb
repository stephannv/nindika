class AddVisitsColumnsToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :all_time_visits, :integer, null: false, default: 0
    add_column :items, :last_week_visits, :integer, null: false, default: 0
    add_index :items, :all_time_visits
    add_index :items, :last_week_visits
  end
end
