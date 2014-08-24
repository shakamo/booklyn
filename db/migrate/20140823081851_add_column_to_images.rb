class AddColumnToImages < ActiveRecord::Migration
  def change
    add_column :images, :table_name, :string
    add_column :images, :generic_id, :integer
  end
end
