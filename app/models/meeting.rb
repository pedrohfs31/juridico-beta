class Meeting < ApplicationRecord
  belongs_to :user
  belongs_to :availability

  validates  :subject, :link, :availability, presence: true

end
