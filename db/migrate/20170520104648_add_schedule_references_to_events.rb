class AddScheduleReferencesToEvents < ActiveRecord::Migration[5.0]
  def change
    add_reference :events, :schedule, foreign_key: true
  end
end
