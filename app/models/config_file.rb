# frozen_string_literal: true

# represents a file containing configuration info that can be uploaded to a
# condition
class ConfigFile < ApplicationRecord
  mount_uploader :file, PrivateFileUploader

  belongs_to :condition

  delegate :url, to: :file
  alias path url

  scope :active, -> { where(active: true) }
  scope :inactive, -> { where(active: false) }
  scope :historical, -> { inactive.order(created_at: :desc) }

  def name
    File.basename(url)
  end
  alias to_s name
end
