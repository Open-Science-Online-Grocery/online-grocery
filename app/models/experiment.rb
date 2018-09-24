class Experiment < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }
  validates :user, presence: true

  belongs_to :user

  has_many :conditions, dependent: :destroy

  scope :for_user, ->(user) { where(user: user) }
end
