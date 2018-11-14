# frozen_string_literal: true

# represents a picture that can be shown on a product
class CartSummaryLabel < ApplicationRecord
  mount_uploader :image, CartSummaryLabelUploader

  scope :built_in, -> { where(built_in: true) }

  def custom?
    !built_in
  end

  def custom_cart_summary_label
    custom? ? self : CartSummaryLabel.new(built_in: false)
  end
end
