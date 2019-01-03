# frozen_string_literal: true

# join model between Condition and CartSummaryLabel
class ConditionCartSummaryLabel < ApplicationRecord
  attr_writer :label_type

  delegate :built_in, :name, :image, :image?,
           to: :cart_summary_label
  delegate :image_url, to: :cart_summary_label, prefix: true, allow_nil: true
  delegate :label_types, to: :class
  delegate :variables, to: :equation, prefix: true

  belongs_to :condition
  belongs_to :cart_summary_label

  accepts_nested_attributes_for :cart_summary_label, allow_destroy: true

  def self.label_types
    OpenStruct.new(provided: 'provided', custom: 'custom')
  end

  def label_type
    return @label_type if @label_type
    return label_types.provided if cart_summary_label.try(:built_in)
    label_types.custom
  end

  def equation
    @equation ||= Equation.for_type(Equation.types.cart, equation_tokens)
  end

  def applies_to_cart?(cart)
    return true if always_show
    equation.evaluate(cart)
  end
end
