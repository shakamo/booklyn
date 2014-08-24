class RemoveColumnFromImages < ActiveRecord::Migration
  def change
    remove_column :images, :tableName, :string
    remove_column :images, :genericId, :string
  end
end
