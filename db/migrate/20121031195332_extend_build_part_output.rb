class ExtendBuildPartOutput < ActiveRecord::Migration
  def up
  	change_column :build_parts, :output, :text, :limit => 16777215
  end

  def down
  end
end
