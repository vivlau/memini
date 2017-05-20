class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.string :event_name
      t.string :start_date
      t.string :start_time
      t.string :end_date
      t.string :end_time
      t.string :event_location
      t.text :event_description
      t.string :categories

      t.timestamps
    end
  end
end
