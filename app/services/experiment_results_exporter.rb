# frozen_string_literal: true

require 'csv'

class ExperimentResultsExporter
  def initialize(experiment)
    @experiment = experiment
  end


  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << product_data_csv_attributes.keys

      product_scope.find_each do |product|
        csv << generate_csv_row(product)
      end
    end
  end

  private def participant_action_attributes
    {
      ''
    }
  end
end
