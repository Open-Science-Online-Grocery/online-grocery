# frozen_string_literal: true

# Class that handles requests made to the Paypal payments API
class PaymentsManager
  def initialize(current_user)
    @current_user = current_user
  end

  # TODO: make request to https://api-m.paypal.com/v1/billing/subscriptions/{id}
  # to check the subscription status
  def has_valid_subscription?
  end

  # curl -v -X POST "https://api-m.sandbox.paypal.com/v1/oauth2/token"    -u "<CLIENT_ID>:<CLIENT_SECRET>"    -H "Content-Type: application/x-www-form-urlencoded"    -d "grant_type=client_credentials"
  private def access_token
  end
end
