class AdminMailer < ApplicationMailer
  def send_creation_email(user_id, api_token_request_id)
    @user = User.find user_id
    @api_token_request = ApiTokenRequest.find api_token_request_id
    mail(to: AdminUser.pluck(:email), subject: "New Api Token Request")
  end
end
