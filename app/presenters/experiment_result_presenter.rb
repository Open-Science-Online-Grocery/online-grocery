# frozen_string_literal: true

#:nodoc:
class ExperimentResultPresenter < SimpleDelegator
  include ActionView::Helpers::TranslationHelper

  def humanized_created_at
    l(created_at)
  end
end
