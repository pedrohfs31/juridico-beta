class Availability < ApplicationRecord
  belongs_to :user
  has_one :meeting

  validates :date, :time, :user, presence: true

end
