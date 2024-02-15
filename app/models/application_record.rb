# frozen_string_literal: true

# :nodoc:
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.ransackable_attributes(_auth_object = nil)
    column_names + _ransackers.keys
  end

  def self.ransackable_associations(_auth_object = nil)
    @ransackable_associations ||= reflect_on_all_associations.map do |a|
      a.name.to_s
    end
  end
end
