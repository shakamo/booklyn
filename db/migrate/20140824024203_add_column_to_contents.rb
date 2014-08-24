class AddColumnToContents < ActiveRecord::Migration
  def change
    add_column :contents, :trim_title, :string
  end
end
