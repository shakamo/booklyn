class CreateContents < ActiveRecord::Migration
  def change
    create_table :contents do |t|
      t.string :title
      t.string :initial
      t.string :description
      t.references :category, index: true
      t.references :schedule, index: true

      t.timestamps
    end
  end
end
