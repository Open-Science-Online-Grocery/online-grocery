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
end
