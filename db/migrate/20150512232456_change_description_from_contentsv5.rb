class ChangeDescriptionFromContentsv5 < ActiveRecord::Migration
  def change
    change_column :contents, :description, :string, limit: 16_384
  end
end
