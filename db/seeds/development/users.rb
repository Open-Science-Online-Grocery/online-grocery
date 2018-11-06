# frozen_string_literal: true

module Seeds
  module Development
    module Users
      def self.seed_other_users
        return if User.many?

        3.times do
          user = User.new(
            email: Faker::Internet.email,
            password: 'adminadmin!1',
            password_confirmation: 'adminadmin!1'
          )
          user.skip_confirmation!
          user.save!
        end
      end
    end
  end
end
