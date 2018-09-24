class Condition < ApplicationRecord
  validates :name, presence: true
  validates :name, uniqueness: { scope: :experiment_id }
  validates :experiment, presence: true

  belongs_to :experiment
end
