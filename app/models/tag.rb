# frozen_string_literal: true

# represents a custom category a product may belong to.
# it should respond to the same API as Category and be able to be used in its place
class Tag < ApplicationRecord
  has_many :subtags, dependent: :destroy
  has_many :product_tags, dependent: :destroy
  has_many :products, through: :product_tags

  accepts_nested_attributes_for :subtags

  alias_attribute :to_s, :name
end
