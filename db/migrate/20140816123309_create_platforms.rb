class CreatePlatforms < ActiveRecord::Migration
  def change
    create_table :platforms do |t|
      t.string :platform_code
      t.string :platform_name

      t.timestamps
    end
    add_index :platforms, :platform_code
  end
end
