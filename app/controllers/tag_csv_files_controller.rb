# frozen_string_literal: true

class TagCsvFilesController < ApplicationController
  power :tag_csv_files, context: :set_tag_csv_file, map: {
    %i[show] => :downloadable_tag_csv_file
  }

  def show
    send_file(@tag_csv_file.path)
  end

  private def set_tag_csv_file
    @tag_csv_file = TagCsvFile.find(params[:id])
  end
end
