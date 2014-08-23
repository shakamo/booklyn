class ChangeDescriptionFromContents < ActiveRecord::Migration
  def change
    change_column :contents, :description, :string, :limit => 1024
  end
end
