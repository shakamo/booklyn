class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :category_code
      t.string :category_name

      t.timestamps
    end
    add_index :categories, :category_code
  end
end
