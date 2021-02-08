# frozen_string_literal: true

class ConfigFile < ApplicationRecord
end

class TagCsvFile < ConfigFile
end

class MakeCsvFilesUseSti < ActiveRecord::Migration[5.2]
  def change
    rename_table :tag_csv_files, :config_files
    rename_column :config_files, :csv_file, :file
    add_column :config_files, :type, :string

    reversible do |dir|
      dir.up do
        ActiveRecord::Base.connection.schema_cache.clear!
        ConfigFile.reset_column_information

        # rubocop:disable Rails/SkipsModelValidations
        ConfigFile.update_all(type: 'TagCsvFile')
        # rubocop:enable Rails/SkipsModelValidations
      end
      dir.down do
        # nothing to do here; the `type` column will be removed if we are
        # rolling back.
      end
    end
  end
end
