class CreateProjectsUsersTable < ActiveRecord::Migration
  def up
    create_table :projects_users, :id => false do |t|
      t.integer :user_id
      t.integer :project_id
    end
    add_index :projects_users, [:project_id, :user_id]
    add_index :projects_users, [:user_id, :project_id]
  end

  def down
    drop_table :projects_users
  end
end
