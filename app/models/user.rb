# frozen_string_literal: true

# represents a researcher who will manage experiments in the rails app
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :validatable, :lockable, :trackable,
         :confirmable

  has_many :experiments, dependent: :destroy

  def needs_to_pay_subscription?
    experiments.map(&:condition_ids).flatten.count > 1
  end
end
