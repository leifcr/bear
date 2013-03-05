class AddTimeoutToProject < ActiveRecord::Migration
  def change
    add_column :projects, :timeout, :integer, :default => 900
  end
end
