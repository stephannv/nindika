class CreateItems < ActiveRecord::Migration[6.1]
  def change
    create_table :items, id: :uuid do |t|
      t.string :title, null: false, limit: 1024
      t.text :description, limit: 8192
      t.citext :slug
      t.string :website_url, limit: 1024
      t.string :nsuid, limit: 32
      t.string :external_id, null: false, limit: 256
      t.string :boxart_url, limit: 1024
      t.string :banner_url, limit: 1024
      t.string :release_date_display, limit: 64
      t.date :release_date
      t.string :content_rating, limit: 64
      t.jsonb :extra, null: false, default: {}
      t.string :publishers, array: true, null: false, default: []
      t.string :developers, array: true, null: false, default: []
      t.string :genres, array: true, null: false, default: []
      t.string :franchises, array: true, null: false, default: []

      t.timestamps
    end

    add_index :items, :external_id, unique: true
  end
end
