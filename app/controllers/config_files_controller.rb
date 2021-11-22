# frozen_string_literal: true

class ConfigFilesController < ApplicationController
  power :no_fallback, context: :set_config_file, map: {
    %i[show] => :downloadable_config_file
  }

  def show
    send_file(@config_file.path)
  end

  private def set_config_file
    @config_file = ConfigFile.find(params[:id])
  end
end
