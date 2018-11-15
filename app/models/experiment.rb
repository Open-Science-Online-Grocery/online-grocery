# frozen_string_literal: true

# represents a behavior science experiment
class Experiment < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }
  validates :user, presence: true

  belongs_to :user
  has_many :experiment_results

  has_many :conditions, dependent: :destroy

  scope :for_user, ->(user) { where(user: user) }
end
