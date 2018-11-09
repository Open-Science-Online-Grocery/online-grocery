# frozen_string_literal: true

# represents a category a product may belong to
class Category < ApplicationRecord
  alias_attribute :to_s, :name
end
