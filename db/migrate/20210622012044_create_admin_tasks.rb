class CreateAdminTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_tasks, id: :uuid do |t|
      t.string :title
      t.string :status
      t.string :message

      t.timestamps
    end
  end
end
