class AddTimesToSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :departure_time, :string
    add_column :schedules, :return_time, :string
  end
end
