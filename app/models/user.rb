# frozen_string_literal: true

# represents a researcher who will manage experiments in the rails app
class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :timeoutable,
         :recoverable, :rememberable, :validatable, :lockable, :trackable,
         :confirmable

  has_many :experiments, dependent: :destroy
end
