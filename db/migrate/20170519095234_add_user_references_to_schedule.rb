class AddUserReferencesToSchedule < ActiveRecord::Migration[5.0]
  def change
    add_reference :schedules, :user, foreign_key: { to_table: :users }
  end
end
