# frozen_string_literal: true

# responsible for paginating pre-sorted records
class Paginator
  # @param records [Array]
  # @param current_page [Integer] the (1-indexed) desired page of records
  def initialize(records, current_page)
    @records = records
    @current_page = current_page
  end

  def records
    first_record_index = ((@current_page - 1) * records_per_page)
    @records[first_record_index...first_record_index + records_per_page]
  end

  def total_pages
    (@records.count / records_per_page.to_f).ceil
  end

  private def records_per_page
    100
  end
end
