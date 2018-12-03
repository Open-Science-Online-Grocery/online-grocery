# frozen_string_literal: true

class DataDownloadsController < ApplicationController
  power :data_downloads, context: :set_experiment, map: {
    %i[index create] => :own_experiment
  }

  def index
    @resource_name = 'Download Data'
  end

  def create
    respond_to do |format|
      format.csv do
        send_data(
          exporter.generate_csv,
          filename: "experiment_#{params[:export_type]}.csv"
        )
      end
    end
  end

  private def exporter
    {
      'actions' => ExperimentResultsExporter.new(@experiment),
      'checkout' =>  ExperimentSummaryExporter.new(@experiment)
    }[params[:export_type]]
  end

  private def set_experiment
    @experiment = Experiment.find(params[:experiment_id])
  end
end
