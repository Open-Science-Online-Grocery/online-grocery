# frozen_string_literal: true

# This controller is used to render static informational pages
class PagesController < ApplicationController
  skip_power_check
  skip_before_action :authenticate_user!,
                     only: %i[getting_started tutorials]

  def getting_started
  end

  def tutorials
  end
end
