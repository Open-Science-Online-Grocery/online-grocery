# frozen_string_literal: true

# represents a picture that can be shown on a product
class Label < ApplicationRecord
  has_one_attached :image

  def custom?
    !built_in
  end
end
