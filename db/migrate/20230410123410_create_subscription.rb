# frozen_string_literal: true

class CreateSubscription < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.string :paypal_subscription_id
      t.belongs_to :user
      t.datetime :start_date
      t.boolean :perpetual_membership

      t.timestamps
    end
  end
end
