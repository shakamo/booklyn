class ChangeDescriptionFromContentsV2 < ActiveRecord::Migration
  def change
    change_column :contents, :description, :string, limit: 2048
  end
end
