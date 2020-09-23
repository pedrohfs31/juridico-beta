class AddAvailabilityIdToMeetings < ActiveRecord::Migration[6.0]
  def change
    add_reference :meetings, :availability, null: false, foreign_key: true
  end
end
