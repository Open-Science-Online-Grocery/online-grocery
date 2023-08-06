# frozen_string_literal: true

module Seeds
  module Staging
    module Users
      def self.seed_admin_user
        return if User.find_by(email: 'admin@admin.com')

        user = User.new(
          email: 'admin@admin.com',
          password: 'adminadmin!1',
          password_confirmation: 'adminadmin!1'
        )
        user.skip_confirmation!
        user.subscription = Subscription.new(
          paypal_subscription_id: 'I-0WJY0YXGJYJY',
          start_date: Time.zone.now,
          perpetual_membership: true
        )
        user.save!
      end
    end
  end
end
