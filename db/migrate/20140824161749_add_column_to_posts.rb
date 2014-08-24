class AddColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :direct_url, :string
  end
end
