class CreateContentsHolders < ActiveRecord::Migration
  def change
    create_table :contents_holders do |t|
      t.string :contents_holder_code
      t.string :contents_holder_name

      t.timestamps
    end
    add_index :contents_holders, :contents_holder_code
  end
end
