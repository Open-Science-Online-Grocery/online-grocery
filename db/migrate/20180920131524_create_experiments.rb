<<<<<<< HEAD
=======
# frozen_string_literal: true

>>>>>>> master
class CreateExperiments < ActiveRecord::Migration[5.2]
  def change
    create_table :experiments do |t|
      t.string :name, null: false
      t.references :user, index: true, null: false

      t.timestamps
    end
  end
end
