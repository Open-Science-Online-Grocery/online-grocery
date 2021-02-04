module IncludesCsvFile
  extend ActiveSupport::Concern

  included do
    mount_uploader :csv_file, PrivateFileUploader

    belongs_to :condition

    delegate :url, to: :csv_file
    alias path url

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :historical, -> { inactive.order(created_at: :desc) }
  end

  def name
    File.basename(url)
  end
  alias to_s name
end
