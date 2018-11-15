# frozen_string_literal: true

# represents a picture that can be shown on a cart summary
class CartSummaryLabel < ApplicationRecord
  mount_uploader :image, CartSummaryLabelUploader

  scope :built_in, -> { where(built_in: true) }

  def custom?
    !built_in
  end
end
