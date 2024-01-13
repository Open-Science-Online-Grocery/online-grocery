class ApiTokenRequestsController < ApplicationController

  skip_power_check

  def create
    api_token_request = ApiTokenRequest.new(api_token_request_params)
    api_token_request.user_id = current_user.id
    if api_token_request.save
      flash[:success] = 'Api Access Token Request is submitted to admins.'
      redirect_to experiments_path
    else
      flash[:error] =  api_token_request.errors.full_messages.first
      redirect_to experiments_path
    end
  end

  private

  def api_token_request_params
    params.require(:api_token_request).permit(:status, :note, :user_id)
  end
end
