# frozen_string_literal: true

CLIENT_ID = Rails.application.credentials.dig(:paypal_api, :client_id)
CLIENT_SECRET = Rails.application.credentials.dig(:paypal_api, :client_secret)

# Class that handles subscriptions and requests made to the Paypal payments API
class PaymentsManager
  attr_accessor :errors

  def initialize(current_user)
    @current_user = current_user
    @errors = []
  end

  def create_subscription(paypal_subscription_id)
    ActiveRecord::Base.connection.transaction do
      @current_user.subscription = Subscription.new(
        paypal_subscription_id: paypal_subscription_id,
        start_date: Time.zone.now
      )
      @current_user.save || @errors += @current_user.errors

      raise(ActiveRecord::Rollback) if @errors.any? || !valid_subscription?
    end
    @errors.empty?
  end

  # rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def valid_subscription?
    return true unless @current_user.needs_subscription?

    return false if @current_user.subscription.blank?
    return true if @current_user.subscription.perpetual_membership
    return false if @current_user.subscription.needs_to_pay?

    data = request_subscription_info
    return true if data['status'].present? && data['status'] == 'ACTIVE'
    @errors << 'The subscription is inactive or invalid'
    false
  end
  # rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  # rubocop:disable Layout/LineLength
  private def request_subscription_info
    connection = Faraday.new do |conn|
      conn.request(:authorization, 'Bearer', access_token)
    end
    JSON.parse(
      connection.get(
        "#{paypal_base_url}/billing/subscriptions/#{@current_user.subscription.paypal_subscription_id}"
      ).body
    )
  end

  # TODO: replace for encrypted client id and secret
  private def access_token
    connection = Faraday.new do |conn|
      conn.request(:authorization, :basic, CLIENT_ID, CLIENT_SECRET)
    end
    response = JSON.parse(
      connection.post(
        "#{paypal_base_url}/oauth2/token",
        'grant_type=client_credentials'
      ).body
    )
    if response['access_token'].blank?
      @errors << 'Unable to access the Paypal API'
      return
    end
    response['access_token']
  end
  # rubocop:enable Layout/LineLength

  private def paypal_base_url
    'https://api-m.sandbox.paypal.com/v1'
  end
end
