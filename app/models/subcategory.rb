# frozen_string_literal: true

# represents a subcategory a product may belong to
class Subcategory < ApplicationRecord
  alias_attribute :to_s, :name
end
