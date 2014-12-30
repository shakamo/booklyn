class ChangeDescriptionFromContentsV3 < ActiveRecord::Migration
  def change
    change_column :contents, :description, :string, :limit => 4096
  end
end
