# frozen_string_literal: true

# represents a picture that can be shown on a product
class Label < ApplicationRecord
  validates :name, presence: true

  mount_uploader :image, FileUploader

  scope :built_in, -> { where(built_in: true) }

  def custom?
    !built_in
  end
end
