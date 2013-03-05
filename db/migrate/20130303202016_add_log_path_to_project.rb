class AddLogPathToProject < ActiveRecord::Migration
  def change
    add_column :projects, :log_path, :string, :default => ""
  end
end
