class CreateApiTokenRequests < ActiveRecord::Migration[6.1]
  def change
    create_table :api_token_requests do |t|
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true
      t.text :note
      t.text :admin_note


      t.timestamps
    end
  end
end
