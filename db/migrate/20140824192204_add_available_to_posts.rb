class AddAvailableToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :available, :string
  end
end
