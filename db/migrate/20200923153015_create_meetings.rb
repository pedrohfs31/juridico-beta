class CreateMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :meetings do |t|
      t.string :subject
      t.string :link
      t.references :user, null: false, foreign_key: true
      t.string :availability

      t.timestamps
    end
  end
end
