# frozen_string_literal: true

# represents a tag/category csv file that can be uploaded to a condition
class TagCsvFile < ApplicationRecord
  mount_uploader :csv_file, ConditionTagCsvUploader

  belongs_to :condition
end
