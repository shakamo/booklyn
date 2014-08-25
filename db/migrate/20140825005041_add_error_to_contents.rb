class AddErrorToContents < ActiveRecord::Migration
  def change
    add_column :contents, :error, :text
  end
end
