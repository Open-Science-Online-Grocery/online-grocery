# frozen_string_literal: true

#:nodoc:
class ConditionPresenter < SimpleDelegator
  alias condition __getobj__

  def custom_label
    label.try(:custom?) ? label : build_label(built_in: false)
  end
end
