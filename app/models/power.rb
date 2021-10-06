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

  power :manageable_conditions do
    Condition.where(experiment_id: own_experiments.select(:id))
  end

  power :downloadable_config_files do
    ConfigFile.where(condition_id: manageable_conditions.select(:id))
  end

  power :config_files do
    nil
  end

  power :experiments do
    nil
  end

  power :products do
    nil
  end
end
