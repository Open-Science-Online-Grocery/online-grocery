# frozen_string_literal: true

# responsible for generating and importing sorting csv files
class SortingCsvManager
  require 'csv'

  attr_reader :errors

  delegate :headers, to: :class

  def self.headers
    [
      'Participant Id',
      'Product Id',
      'Product Rank'
    ]
  end

  def self.generate_csv(condition)
    CSV.generate(headers: true) do |csv|
      csv << headers

      condition.products.find_each do |product|
        csv << ['', product.id, '']
      end
    end
  end
end
