# frozen_string_literal: true

# join model connecting products to their tags and subtags
class ProductTag < ApplicationRecord
  belongs_to :product
  belongs_to :tag
  belongs_to :subtag, optional: true
end
