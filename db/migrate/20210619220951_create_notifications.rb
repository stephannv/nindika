class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :subject, polymorphic: true, null: false, type: :uuid, index: true
      t.string :notification_type, null: false
      t.string :title, null: false
      t.string :body
      t.string :url
      t.string :image_url
      t.jsonb :fields, default: {}, null: false

      t.timestamps
    end
  end
end
