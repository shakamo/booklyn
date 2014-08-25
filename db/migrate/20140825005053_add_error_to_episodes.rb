class AddErrorToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :error, :text
  end
end
