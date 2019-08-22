# frozen_string_literal: true

module Seeds
  module Base
    def self.seed_base
      Seeds.seed_from(Seeds::Base::Categories)
      Seeds.seed_from(Seeds::Base::Products)
      Seeds.seed_from(Seeds::Base::Labels)
      Seeds.seed_from(Seeds::Base::CartSummaryLabels)
      Seeds.seed_from(Seeds::Base::ProductSortFields)
    end
  end
end
