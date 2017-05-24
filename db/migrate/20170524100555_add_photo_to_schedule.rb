class AddPhotoToSchedule < ActiveRecord::Migration[5.0]
  def change
    add_column :schedules, :photo, :string
  end
end
