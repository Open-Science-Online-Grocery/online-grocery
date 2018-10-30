# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  validates :name, :uuid, presence: true
  validates :name, uniqueness: { scope: :experiment_id }

  belongs_to :experiment

  def url
    "http://www.howesgrocery.com?condId=#{uuid}"
  end
end
