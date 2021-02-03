class CreateSuggestionCsvFiles < ActiveRecord::Migration[5.2]
  def change
    create_table :suggestion_csv_files do |t|
      t.string :csv_file
      t.references :condition
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
