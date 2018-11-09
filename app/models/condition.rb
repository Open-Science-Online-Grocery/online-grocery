# frozen_string_literal: true

# represents an experimental condition
class Condition < ApplicationRecord
  attr_writer :label_type
  attr_accessor :show_food_count

  validates :name, :uuid, presence: true
  validates :name, uniqueness: { scope: :experiment_id }

  belongs_to :experiment
  belongs_to :label, optional: true

  accepts_nested_attributes_for :label

  # TODO: update if needed
  def url
    "http://www.howesgrocery.com?condId=#{uuid}"
  end

  def label_type
    return @label_type if @label_type
    return 'none' if label.nil?
    label.built_in? ? 'provided' : 'custom'
  end
end
