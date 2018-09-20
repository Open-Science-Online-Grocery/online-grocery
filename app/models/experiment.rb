class Experiment < ApplicationRecord
  validates :name, presence: true
  validates :user, presence: true

  belongs_to :user

  scope :for_user, ->(user) { where(user: user) }
end
