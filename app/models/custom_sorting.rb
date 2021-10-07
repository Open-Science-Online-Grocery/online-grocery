# frozen_string_literal: true

class CustomSorting < ApplicationRecord
  # used for error reporting during SortFile import
  attr_accessor :csv_row_number

  validates :sort_order, presence: true
  validates :sort_order,
            uniqueness: { scope: %i[condition_id session_identifier] }
  validates :product_id,
            uniqueness: { scope: %i[condition_id session_identifier] }

  belongs_to :condition
  belongs_to :sort_file
  belongs_to :product

  scope :for_session_identifier, ->(session_identifier) do
    where(session_identifier: session_identifier)
  end
end
