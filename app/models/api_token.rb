# frozen_string_literal: true

# Represents a token which is assigned to a user to allow him to make api requst
# and can use auto cart populate feature
class ApiToken < ApplicationRecord
  belongs_to :user
  belongs_to :api_token_request, optional: true
end
