# frozen_string_literal: true

# Manages the initialization of experiments
class ExperimentManager
  attr_accessor :errors

  def initialize(current_user)
    @current_user = current_user
    @errors = []
  end

end
