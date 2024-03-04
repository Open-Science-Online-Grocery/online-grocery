# frozen_string_literal: true

# Represents api token requests requested by users
class ApiTokenRequest < ApplicationRecord
  has_one :api_token, dependent: :destroy
  belongs_to :user

  scope :pending, -> { where(status: 0) }
  scope :approved, -> { where(status: 1) }
  scope :rejected, -> { where(status: 2) }

  enum status: { :pending => 0, :approved => 1, :rejected => 2 }

  after_save :create_api_token
  after_update_commit :send_update_status_email
  after_create_commit :send_creation_email

  private def create_api_token
    return unless status == 'approved' && api_token.blank?
    ApiToken.create!(
      uuid: SecureRandom.uuid, api_token_request_id: id,
      user_id: user_id
    )
  end

  private def send_update_status_email
    UserMailer.update_api_token_request_status(user_id, id).deliver_now if %w[
      approved rejected
    ].include?(saved_change_to_status[1])
  end

  private def send_creation_email
    AdminMailer.send_creation_email(user_id, id).deliver_now
  end
end
