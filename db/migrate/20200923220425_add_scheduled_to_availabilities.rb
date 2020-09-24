class AddScheduledToAvailabilities < ActiveRecord::Migration[6.0]
  def change
    add_column :availabilities, :scheduled, :boolean, default: false
  end
end
