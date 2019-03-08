# frozen_string_literal: true

require 'csv'

# creates a CSV of participant actions for an Experiment
class ParticipantActionsExporter
  attr_reader :errors

  def initialize(experiment)
    @experiment = experiment
    @errors = []
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      if result_presenters.blank?
        add_no_data_error
        break
      end

      csv << experiment_result_attributes.keys

      result_presenters.each do |result|
        csv << generate_csv_row(result)
      end
    end
  end

  private def experiment_result_attributes
    {
      'Experiment Name' => :experiment_name,
      'Condition Name' => :condition_name,
      'Session Identifier' => :session_identifier,
      'Participant Action Type' => :action_type,
      'Product Name' => :product_name,
      'Quantity' => :quantity,
      'Participant Action Date/Time' => :humanized_created_at
    }
  end

  private def result_presenters
    @experiment.experiment_results.map do |result|
      ExperimentResultPresenter.new(result)
    end
  end

  private def generate_csv_row(result)
    experiment_result_attributes.values.map do |method_symbol|
      result.public_send(method_symbol)
    end
  end

  private def add_no_data_error
    @errors << 'There is no participant actions data available for export.'
  end
end
