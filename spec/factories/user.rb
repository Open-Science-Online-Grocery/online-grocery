# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { 'supersecret!1' }
    password_confirmation { 'supersecret!1' }
    confirmed_at { Time.zone.today }
  end
end
