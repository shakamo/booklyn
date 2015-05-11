class AddColumnTidAndAkid < ActiveRecord::Migration
  def change
    add_column :contents, :tid, :integer
    add_column :contents, :akid, :integer
  end
end
