# frozen_string_literal: true

# represents a researcher who will manage experiments in the rails app
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :validatable, :lockable, :trackable,
         :confirmable

  has_many :experiments, dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_one :api_token, dependent: :destroy
  has_one :api_token_request, dependent: :destroy

  def needs_subscription?
    experiments.map(&:condition_ids).flatten.count >= 1
  end
end
