# frozen_string_literal: true

# represents a product in a grocery store
class Product < ApplicationRecord
  # these `alias_attribute` calls are needed because the database (which we do
  # not control) has column names using camel case. here we make them accessible
  # via snake case as well in keeping with rails conventions
  alias_attribute :image_src, :imageSrc
  alias_attribute :serving_size, :servingSize
  alias_attribute :calories_from_fat, :caloriesFromFat
  alias_attribute :saturated_fat, :saturatedFat
  alias_attribute :trans_fat, :transFat
  alias_attribute :poly_fat, :polyFat
  alias_attribute :mono_fat, :monoFat
  alias_attribute :category_id, :category
  alias_attribute :subcategory_id, :subcategory

  belongs_to :category
  belongs_to :subcategory

  scope :name_matches, ->(string) {
    where(arel_table[:name].matches("%#{string}%"))
  }
end
