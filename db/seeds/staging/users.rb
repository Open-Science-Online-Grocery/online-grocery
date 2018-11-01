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
        user.save!
      end
    end
  end
end
