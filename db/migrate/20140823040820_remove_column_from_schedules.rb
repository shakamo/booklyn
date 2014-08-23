class RemoveColumnFromSchedules < ActiveRecord::Migration
  def change
    remove_column :schedules, :year, :string
    remove_column :schedules, :month, :string
    remove_column :schedules, :day, :string
  end
end
