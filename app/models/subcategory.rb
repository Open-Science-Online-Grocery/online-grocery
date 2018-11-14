# frozen_string_literal: true

# represents a subcategory a product may belong to
class Subcategory < ApplicationRecord
  belongs_to :category
end
