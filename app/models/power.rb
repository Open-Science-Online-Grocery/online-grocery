# frozen_string_literal: true

# captures permissions based upon the current logged-in user.
# refer to the Consul gem documentation.
class Power
  include Consul::Power

  def initialize(user, request: nil)
    @user = user
    @request = request
  end

  power :own_experiments do
    Experiment.where(user_id: @user.id)
  end

  power :may_create_experiments do
    PaymentsManager.new(@user).valid_subscription?
  end

  power :manageable_conditions do
    Condition.where(experiment_id: own_experiments.select(:id))
  end

  power :downloadable_config_files do
    ConfigFile.where(condition_id: manageable_conditions.select(:id))
  end

  # to ensure each action in a controller has a specified power, we use this
  # power as the fallback/default power for controller power mappings.
  # it ensures that unmapped actions are not accessible.
  power :no_fallback do |*_args|
    raise(
      Consul::UncheckedPower,
      "Please specify a power for the #{@request.params[:action]} action in " \
        "the #{@request.params[:controller]} controller"
    )
  end
end
