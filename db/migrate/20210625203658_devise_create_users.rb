# frozen_string_literal: true

class DeviseCreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users, id: :uuid do |t|
      t.string :name
      t.string :email
      t.string :provider, null: false
      t.string :uid, null: false
      t.string :profile_image_url

      t.timestamps null: false
    end

    add_index :users, %i[provider uid], unique: true
  end
end
