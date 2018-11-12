# frozen_string_literal: true

# responsible for collecting/formatting info about a Condition for consumption
# by the grocery store react app
class ConditionSerializer
  def initialize(condition)
    @condition = condition
  end

  def serialize
    { sort_fields: @condition.product_sort_fields.map(&:description) }
  end
end
