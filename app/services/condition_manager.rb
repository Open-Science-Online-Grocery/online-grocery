# frozen_string_literal: true

# responsible for any extra data manipulation needed when setting attributes on
# or saving a condition
class ConditionManager
  attr_reader :errors

  def initialize(condition, params)
    @condition = condition
    @params = params
    @csv_file = nil
    @errors = []
  end

  def assign_params
    add_uuid_to_new_record
    clear_unselected_label_fields
    save_csv_file
    clear_unselected_sort_fields
    @condition.attributes = @params
  end

  def update_condition
    ActiveRecord::Base.transaction do
      assign_params
      deactivate_current_csv
      import_tags
      @errors += @condition.errors.full_messages unless @condition.save
      raise ActiveRecord::Rollback if @errors.any?
    end
    @errors.none?
  end

  private def add_uuid_to_new_record
    return unless @condition.new_record?
    @condition.uuid = SecureRandom.uuid
  end

  # rubocop:disable Style/GuardClause
  private def clear_unselected_label_fields
    if @params[:label_type] == Condition.label_types.custom
      @params.delete(:label_id)
    else
      @params.delete(:label_attributes)
    end
    if @params[:label_type] == Condition.label_types.none
      @params[:label_id] = nil
    end
  end

  private def clear_unselected_sort_fields
    if @params[:sort_type] != Condition.sort_types.field
      @params[:default_sort_field_id] = nil
      @params[:default_sort_order] = nil
    end
    if @params[:sort_type] != Condition.sort_types.calculation
      @params[:sort_equation_tokens] = nil
    end
  end

  private def deactivate_current_csv
    # coerce to boolean, false is converted to null by ajax form refresh
    active = !@params.delete(:current_csv_file_active).nil?
    current_csv_file = @condition.current_tag_csv_file
    if current_csv_file
      current_csv_file.update!(active: active)
      @condition.product_tags.destroy_all unless active
    end
  end

  private def save_csv_file
    @csv_file = @params[:csv_file]
    return unless @csv_file
    @condition.tag_csv_files.find_each { |file| file.active = false }
    @condition.tag_csv_files.build(csv_file: @csv_file)
    @params.delete(:csv_file)
  end

  private def import_tags
    # users can only upload one file at a time
    return unless @csv_file.present?

    tag_importer = TagImporter.new(file: @csv_file, condition: @condition)
    @condition.product_tags.destroy_all
    raise ActiveRecord::Rollback unless tag_importer.import
    @errors += tag_importer.errors
  end
  # rubocop:enable Style/GuardClause
end
