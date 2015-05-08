class ChangeDescriptionFromContentsV4 < ActiveRecord::Migration
  def change
    change_column :contents, :description, :string, limit: 8192
  end
end
