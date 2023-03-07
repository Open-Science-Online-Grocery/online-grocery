# frozen_string_literal: true

# :nodoc:
class ExperimentResultPresenter < SimpleDelegator
  include ActionView::Helpers::TranslationHelper

  def humanized_performed_at
    localize(performed_at, format: :with_seconds)
  end
end
