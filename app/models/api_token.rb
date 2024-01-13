class ApiToken < ApplicationRecord
  belongs_to :user
  belongs_to :api_token_request, optional: true
end
