# frozen_string_literal: true

# Carrierwave uploader to add images to Label objects
class LabelImageUploader < CarrierWave::Uploader::Base
  storage :file

  def store_dir
    Rails.root.join(
      'uploads',
      model.class.to_s.underscore,
      mounted_as.to_s,
      model.id.to_s
    )
  end
end
