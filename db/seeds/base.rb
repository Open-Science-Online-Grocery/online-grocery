# frozen_string_literal: true

module Seeds
  module Base
    def self.seed_base
      Seeds.seed_from(Seeds::Base::Categories)
    end
  end
end
