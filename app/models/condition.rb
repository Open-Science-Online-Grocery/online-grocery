# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  attr_accessor :label_type

  validates :name, :uuid, presence: true
  validates :name, uniqueness: { scope: :experiment_id }

  belongs_to :experiment

  has_one_attached :custom_image

  # TODO: update if needed
  def url
    "http://www.howesgrocery.com?condId=#{uuid}"
  end
end
