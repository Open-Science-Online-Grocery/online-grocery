# frozen_string_literal: true

# represents a user paid subscription
class Subscription < ApplicationRecord
  belongs_to :user

  def subscription_length
    1.year
  end

  def needs_to_pay?
    Time.zone.now > (start_date + subscription_length)
  end
end
