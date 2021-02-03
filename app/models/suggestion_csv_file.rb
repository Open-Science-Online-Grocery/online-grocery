# frozen_string_literal: true

# represents a "suggested add-on" csv file that can be uploaded to a condition
class SuggestionCsvFile < ApplicationRecord
  include IncludesCsvFile
end
