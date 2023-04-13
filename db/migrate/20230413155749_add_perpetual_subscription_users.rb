# frozen_string_literal: true

class AddPerpetualSubscriptionUsers < ActiveRecord::Migration[6.1]
  def up
    ActiveRecord::Base.connection.schema_cache.clear!
    User.reset_column_information

    users_emails = []
    scimed_users = User.where('email LIKE ?', '%scimedsolutions.com%')
    scimed_users.each { |user| create_subscription(user) }

    users_emails.each do |email|
      user = User.find(email: email)
      next unless user
      create_subscription(user)
    end
  end

  private def create_subscription(user)
    user.subscription = Subscription.new(
      start_date: Time.zone.now,
      perpetual_membership: true
    )
    user.save!
  end

  private def users_emails
    %w[
      Holly.howe@hec.ca
      Holly.s.howe@gmail.com
      Holly.howe@duke.edu
      EDRProgram@chop.edu
      makaraa@chop.edu
      kreterv@chop.edu
      peter.ubel@duke.edu
      shemal.doshi@insead.edu
      jad.chaaban@insead.edu
      Pierre.chandon@insead.edu
      gary.gebhardt@hec.ca
      rodrigo.dias@duke.edu
      boya.xu@duke.edu
      mela@duke.edu
    ]
  end
end
