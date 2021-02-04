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

    ActiveRecord::Base.connection.schema_cache.clear!
    User.reset_column_information

    # rubocop:disable Rails/SkipsModelValidations
    ConfigFile.update_all(type: 'TagCsvFile')
    # rubocop:enable Rails/SkipsModelValidations
  end
end
