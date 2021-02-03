module IncludesCsvFile
  extend ActiveSupport::Concern

  included do
    mount_uploader :csv_file, FileUploader

    belongs_to :condition

    delegate :url, to: :csv_file
    alias path url

    scope :active, -> { where(active: true) }
    scope :inactive, -> { where(active: false) }
    scope :current, -> { active.order(created_at: :desc).limit(1) }
    scope :historical, -> { inactive.order(created_at: :desc) }
  end

  def name
    File.basename(url)
  end
  alias to_s name
end
