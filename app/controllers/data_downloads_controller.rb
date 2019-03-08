# frozen_string_literal: true

class DataDownloadsController < ApplicationController
  power :data_downloads, context: :set_experiment, map: {
    %i[index create] => :own_experiment
  }

  before_action :set_breadcrumbs

  def index
  end

  def create
    respond_to do |format|
      format.csv do
        current_exporter = exporter
        csv_data = current_exporter.generate_csv
        if current_exporter.errors.blank?
          send_data(
            csv_data,
            filename: "experiment_#{params[:export_type]}.csv"
          )
        else
          flash[:error] = current_exporter.errors.join(', ')
          redirect_to experiment_data_downloads_path(@experiment)
        end
      end
    end
  end

  private def exporter
    {
      'actions' => ParticipantActionsExporter.new(@experiment),
      'checkout' => CheckoutProductsExporter.new(@experiment)
    }[params[:export_type]]
  end

  private def set_experiment
    @experiment = Experiment.find(params[:experiment_id])
  end

  private def set_breadcrumbs
    @breadcrumbs = [
      OpenStruct.new(name: @experiment.name, path: experiment_path(@experiment))
    ]
    @resource_name = 'Download Data'
  end
end
