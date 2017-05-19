class CreateSchedules < ActiveRecord::Migration[5.0]
  def change
    create_table :schedules do |t|
      t.string :location
      t.string :departure_date
      t.string :return_date
      t.string :traveller_type

      t.timestamps
    end
  end
end
