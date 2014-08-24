class RemoveColumnFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :is_available, :string
  end
end
