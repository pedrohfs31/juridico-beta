class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :availability

  validates  :subject, :availability, presence: true

  after_save :scheduled_true
  after_destroy :scheduled_false

  private

  def scheduled_true
    self.availability.scheduled = true
    self.availability.save!
  end

  def scheduled_false

    if current_user == self.availability.user
      self.availability.destroy
    else
      self.availability.scheduled = false
      self.availability.save!
    end

  end
end
