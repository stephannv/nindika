class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items, id: :uuid do |t|
      t.string :title, null: false, limit: 1024
      t.text :description
      t.citext :slug, null: false
      t.string :website_url, limit: 1024
      t.string :nsuid, limit: 32
      t.string :external_id, null: false, limit: 256
      t.string :boxart_url, limit: 2048
      t.string :banner_url, limit: 2048
      t.string :release_date_display, limit: 64
      t.date :release_date
      t.jsonb :extra, null: false, default: {}
      t.string :publishers, default: [], null: false, array: true
      t.string :developers, default: [], null: false, array: true
      t.string :genres, default: [], null: false, array: true
      t.string :franchises, default: [], null: false, array: true
      t.integer :all_time_visits, default: 0, null: false
      t.integer :last_week_visits, default: 0, null: false

      t.timestamps
    end

    add_index :items, :external_id, unique: true
  end
end
