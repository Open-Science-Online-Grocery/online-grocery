# frozen_string_literal: true

module Seeds
  module Staging
    def self.seed_staging
      Seeds.seed_from(Seeds::Staging::Users)
    end
  end
end
