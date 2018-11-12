# frozen_string_literal: true

# represents a field products may be sorted on in the grocery store
class ProductSortField < ApplicationRecord
  validates :name, :description, presence: true, uniqueness: true

  # names of ProductSortFields that refer to string data
  def self.string_fields
   %w[name label_image_url]
  end

  def string_field?
    self.class.string_fields.include?(name)
  end
end
