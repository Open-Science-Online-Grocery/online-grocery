# frozen_string_literal: true

module Seeds
  module Development
    def self.seed_development
      Seeds.seed_from(Seeds::Development::Users)
      Seeds.seed_from(Seeds::Development::Experiments)
      Seeds.seed_from(Seeds::Development::Conditions)
    end
  end
end
