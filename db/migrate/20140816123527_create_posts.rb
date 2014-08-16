class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :post
      t.string :url
      t.string :short_url
      t.references :episode, index: true
      t.references :contents_holder, index: true
      t.references :platform, index: true
      t.boolean :is_available

      t.timestamps
    end
  end
end
