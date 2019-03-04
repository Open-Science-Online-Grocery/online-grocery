# frozen_string_literal: true

# represents a picture that can be shown on a product
class Label < ApplicationRecord
  mount_uploader :image, LabelImageUploader

  validates :name, presence: true, uniqueness: true

  scope :built_in, -> { where(built_in: true) }

  def custom?
    !built_in
  end
end
