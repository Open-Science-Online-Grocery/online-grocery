# frozen_string_literal: true

# Carrierwave uploader to add images to CartSummaryLabel objects
class CartSummaryLabelUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
