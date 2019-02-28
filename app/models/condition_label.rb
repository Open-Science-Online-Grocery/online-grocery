# frozen_string_literal: true

# join model between Condition and Label
class ConditionLabel < ApplicationRecord
  attr_writer :label_type

  delegate :built_in, :name, :image, :image_url, :image?,
           to: :label
  delegate :image_url, to: :label, prefix: true, allow_nil: true
  delegate :label_types, to: :class
  delegate :variables, to: :equation, prefix: true

  belongs_to :condition
  belongs_to :label

  accepts_nested_attributes_for :label, allow_destroy: true

  def self.label_types
    OpenStruct.new(provided: 'provided', custom: 'custom')
  end

  def label_type
    return @label_type if @label_type
    return label_types.provided if label.try(:built_in)
    label_types.custom
  end

  def equation
    @equation ||= Equation.for_type(
      Equation.types.label,
      equation_tokens
    )
  end

  def applies_to_cart?(cart)
    return true if always_show
    equation.evaluate(cart)
  end

  def custom_label
    label.try(:custom?) ? label : Label.new(built_in: false)
  end

  def label_position_options
    [
      'top left',
      'top center',
      'top right',
      'center left',
      'center',
      'center right',
      'bottom left',
      'bottom center',
      'bottom right'
    ]
  end
end
