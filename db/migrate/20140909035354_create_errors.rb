class CreateErrors < ActiveRecord::Migration
  def change
    create_table :errors do |t|
      t.string :name
      t.text :description
      t.text :url

      t.timestamps
    end
  end
end
