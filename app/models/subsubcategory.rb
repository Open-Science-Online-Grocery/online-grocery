# frozen_string_literal: true

# represents a subsubcategory (a further division of subcategory) that
# a product may belong to
class Subsubcategory < ApplicationRecord
  belongs_to :subcategory

  alias_attribute :to_s, :name
end
