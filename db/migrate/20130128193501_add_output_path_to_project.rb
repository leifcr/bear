class AddOutputPathToProject < ActiveRecord::Migration
  def change
    add_column :projects, :output_path, :string, :default => ""
  end
end
