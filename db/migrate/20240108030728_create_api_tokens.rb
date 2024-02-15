# frozen_string_literal: true

class CreateApiTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :api_tokens do |t|
      t.string :uuid, null: false
      t.references :user
      t.references :api_token_request

      t.timestamps
    end
  end
end
