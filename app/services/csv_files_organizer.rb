# frozen_string_literal: true

# Class that manages the csv templates creation and storage on the system
class CsvFilesOrganizer
  delegate :target_directory, to: :class

  def self.clear_files
    old_files = Dir.children(target_directory).select do |file|
      file.match(/[a-zA-Z].csv/)
    end
    old_files.each do |file|
      File.delete(target_directory.join(file))
    end
  end

  def self.target_directory
    Rails.root.join('tmp')
  end

  def initialize(filename, csv_generator_class, condition)
    @filename = filename
    @csv_generator_class = csv_generator_class
    @condition = condition
  end

  def handle_csv_file
    existing_file = search_existing_file
    if existing_file.present?
      target_directory.join(existing_file).to_s
    else
      create_new_file
    end
  end

  private def search_existing_file
    Dir.children(target_directory).find do |file|
      file.match(@filename)
    end
  end

  private def create_new_file
    new_file = File.new(Rails.root.join(target_directory.join(@filename)), 'w')
    new_file.write(@csv_generator_class.generate_csv(@condition))
    new_file.path
  end
end
