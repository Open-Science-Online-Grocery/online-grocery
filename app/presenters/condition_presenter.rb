# frozen_string_literal: true

#:nodoc:
class ConditionPresenter < SimpleDelegator
  alias condition __getobj__

  def custom_label
    label.try(:custom?) ? label : Label.new(built_in: false)
  end

  def label_position_options
    [
      'top left',
      'top center',
      'top right',
      'center left',
      'center',
      'center right',
      'bottom left',
      'bottom center',
      'bottom right'
    ]
  end

  def current_csv_file_active
    condition.current_tag_csv_file.present?
  end

  def current_tag_csv_file_presenter
    ResourcePresenter.new(current_tag_csv_file)
  end

  def historical_tag_csv_files_presenters
    historical_tag_csv_files.map do |tag_csv_file|
      ResourcePresenter.new(tag_csv_file)
    end
  end
end
