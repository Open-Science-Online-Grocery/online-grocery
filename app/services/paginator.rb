# frozen_string_literal: true

# responsible for paginating pre-sorted records
class Paginator
  RECORDS_PER_PAGE = 100

  attr_reader :current_page

  # @param records [Array]
  # @param current_page [Integer] the (1-indexed) desired page of records
  def initialize(records, current_page = 1)
    @records = records
    @current_page = current_page
  end

  def records
    first_record_index = ((@current_page - 1) * RECORDS_PER_PAGE)
    @records[first_record_index...first_record_index + RECORDS_PER_PAGE]
  end

  def total_pages
    (@records.count / RECORDS_PER_PAGE.to_f).ceil
  end
end
