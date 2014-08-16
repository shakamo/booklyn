class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.string :schedule_code
      t.string :schedule_name
      t.string :year
      t.string :month
      t.string :day
      t.string :week

      t.timestamps
    end
    add_index :schedules, :schedule_code
  end
end
