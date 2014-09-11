class CreateDirectUrls < ActiveRecord::Migration
  def change
    create_table :direct_urls do |t|
      t.integer :post_id
      t.string :direct_url

      t.timestamps
    end
  end
end
