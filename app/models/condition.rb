# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  validates :name, :uuid, presence: true
  validates :name, uniqueness: { scope: :experiment_id }

  belongs_to :experiment
  has_many :nutrition_styles

  # TODO: update if needed
  def url
    "http://www.howesgrocery.com?condId=#{uuid}"
  end
end
