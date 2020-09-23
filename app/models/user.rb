class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :meetings, dependent: :destroy
  has_many :availabilities, dependent: :destroy

  # validations
  validates :email, :company, presence: true
  validates :email, uniqueness: true
  validates :email, format: { with: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/,
    message: "Only valid email" }
end
