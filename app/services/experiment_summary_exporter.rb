# frozen_string_literal: true

require 'csv'

# creates a CSV of products in the cart at checkout for each participant in
# a given Experiment
class ExperimentSummaryExporter
  def initialize(experiment)
    @experiment = experiment
  end

  def generate_csv
    CSV.generate(headers: true) do |csv|
      csv << rows.first.keys
      rows.each { |row| csv << row }
    end
  end

  private def rows
    @rows ||= results_by_participant.map do |session_identifier, results|
      participant_row(session_identifier, results)
    end
  end

  private def results_by_participant
    @results_by_participant ||= @experiment.experiment_results
      .includes(:product)
      .where(action_type: 'checkout')
      .group_by(&:session_identifier)
  end

  private def participant_row(session_identifier, results)
    {'Participant' => session_identifier }
      .merge(all_product_fields(results))
      .merge(total_fields(results))
  end

  private def all_product_fields(results)
    # the format of this csv entails that every row have as many product columns
    # as the row for the participant with the most products. here we pad the
    # array of results with `nil`s to generate the columns needed for rows with
    # fewer products.
    padded_results = Array.new(max_product_count) { |i| results[i] }
    fields = {}
    padded_results.each_with_index do |result, index|
      fields.merge!(product_fields(result.try(:product), index))
    end
    fields
  end

  private def product_fields(product, index)
    ordered_fields = %i[name price category] + nutrition_fields
    ordered_fields.each_with_object({}) do |field, data|
      data["Item#{index + 1}_#{field.capitalize}"] = product.try(:field)
    end
  end

  private def total_fields(results)
    {}
  end

  private def max_product_count
    @max_product_count ||= results_by_participant.values.max_by(&:length).length
  end

  private def nutrition_fields
    %i[
      calories_from_fat
      calories
      total_fat
      saturated_fat
      trans_fat
      poly_fat
      mono_fat
      cholesterol
      sodium
      potassium
      carbs
      fiber
      sugar
      protein
      vitamins
      starpoints
    ]
  end
end
