# frozen_string_literal: true

#:nodoc:
class ConditionPresenter < SimpleDelegator
  alias condition __getobj__

  def custom_label
    label.try(:custom?) ? label : Label.new(built_in: false)
  end

  def label_type
    return 'none' if label.nil?
    label.built_in? ? 'provided' : 'custom'
  end
end
