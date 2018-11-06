# frozen_string_literal: true

module Seeds
  module Base
    def self.seed_base
      Seeds.seed_from(Seeds::Base::Categories)
      Seeds.seed_from(Seeds::Base::Subcategories)
      Seeds.seed_from(Seeds::Base::Products)
    end
  end
end
