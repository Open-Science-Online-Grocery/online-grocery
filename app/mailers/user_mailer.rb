class UserMailer < ApplicationMailer
  def update_api_token_request_status(user_id, api_token_request_id)
    @user = User.find user_id
    @api_token_request = ApiTokenRequest.find api_token_request_id
    @status = @api_token_request.status == :rejected? ? 'Rejected / Revoked' : 'Approved'
    mail(to: @user.email, subject: "Your Api Access Token Request is #{@status}")
  end
end
