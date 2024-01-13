class ApiTokenRequest < ApplicationRecord
  has_one :api_token, dependent: :destroy
  belongs_to :user

  scope :pending , -> { where(status: 0) }
  scope :approved , -> { where(status: 1) }
  scope :rejected , -> { where(status: 2) }

  enum status: [:pending, :approved, :rejected]

  after_save :create_api_token
  after_update_commit :send_update_status_email
  after_create_commit :send_creation_email

  private

  def create_api_token
    ApiToken.create(uuid: SecureRandom.uuid, api_token_request_id: self.id, user_id: self.user_id) if self.status == "approved" && self.api_token.blank?
  end

  def send_update_status_email
    UserMailer.update_api_token_request_status(self.user_id, self.id).deliver_now if ['approved', 'rejected'].include? saved_change_to_status[1]
  end

  def send_creation_email
    AdminMailer.send_creation_email(self.user_id, self.id).deliver_now
  end
end
