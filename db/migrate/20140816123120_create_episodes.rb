class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :episode_num
      t.string :episode_name
      t.references :content, index: true

      t.timestamps
    end
    add_index :episodes, :episode_num
  end
end
