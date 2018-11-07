# frozen_string_literal: true

# represents a custom subcategory a product may belong to,
# it should respond to the same API as Subcategory and be able to be used in its place
class Subtag < ApplicationRecord
  belongs_to :tag

  has_many :product_tags, dependent: :destroy
  has_many :products, through: :product_tags
end
