# frozen_string_literal: true

# captures permissions based upon the current logged-in user.
# refer to the Consul gem documentation.
class Power
  include Consul::Power

  def initialize(user)
    @user = user
  end

  power :own_experiments do
    Experiment.where(user_id: @user.id)
  end

  power :downloadable_products do
    Product.all if @user
  end

  power :downloadable_tag_csv_files do
    TagCsvFile.joins(:condition).where(
      conditions: { experiment_id: own_experiments.select(:id) }
    )
  end

  power :tag_csv_files do
    nil
  end

  power :experiments do
    nil
  end

  power :products do
    nil
  end
end
