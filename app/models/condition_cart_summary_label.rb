# frozen_string_literal: true

# join model between Condition and CartSummaryLabel
class ConditionCartSummaryLabel < ApplicationRecord
  attr_writer :label_type, :equation

  delegate :built_in, :name, :image, :image?,
           to: :cart_summary_label

  belongs_to :condition
  belongs_to :cart_summary_label

  accepts_nested_attributes_for :cart_summary_label # , reject_if: :all_blank

  def label_type
    return @label_type if @label_type
    cart_summary_label.try(:built_in) ? 'provided' : 'custom'
  end

  def equation
    return @equation if @equation
    # return false when there are no tokens
    label_equation_tokens == '[]' ? 'true' : 'false'
  end

  def equation?
    return true if @equation == 'true'
    false # false or default
  end
end
