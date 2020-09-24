class RemoveAvailabilityFromMeeting < ActiveRecord::Migration[6.0]
  def change
    remove_column :meetings, :availability
  end
end
