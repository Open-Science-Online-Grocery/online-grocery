# frozen_string_literal: true

class TagFileManager
  attr_reader :errors

  def initialize(condition, new_tag_file)
    @condition = condition
    @new_tag_file = new_tag_file
    @errors = []
  end

  def use_new_tag_file
    deactivate_other_tag_files
    @condition.product_tags.destroy_all
    import_new_tags
    @errors.none?
  end

  private def deactivate_other_tag_files
    @condition.tag_csv_files.without(@new_tag_file).each do |tag_file|
      tag_file.update(active: false) || @errors += tag_file.errors.full_messages
    end
  end

  private def import_new_tags
    tag_importer = TagImporter.new(file: @new_tag_file.csv_file, condition: @condition)
    @errors += tag_importer.errors unless tag_importer.import
  rescue => e
    binding.pry
  end
end
