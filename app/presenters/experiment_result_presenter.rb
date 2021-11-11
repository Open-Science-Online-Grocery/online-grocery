# frozen_string_literal: true

#:nodoc:
class ExperimentResultPresenter < SimpleDelegator
  include ActionView::Helpers::TranslationHelper

  def humanized_created_at
    localize(created_at, format: :with_seconds)
  end
end
