# frozen_string_literal: true

class ResourceDownloadsController < ApplicationController
  before_action :set_resource

  def show
    send_file(@resource.path)
  end

  private def set_resource
    @resource = ResourcePresenter.new(resource_from_params)
  end

  private def resource_from_params
    resource_type = params[:resource_type]
    resource_id = params[:id]

    resource_type.constantize.find(resource_id)
  end
end
