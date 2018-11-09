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
    deactivate_current_csv
    save_csv_file
    @condition.attributes = @params
  end

  def update_condition
    assign_params
    import_tags
    return false if @errors.any?
    @errors += @condition.errors.full_messages unless @condition.save
    @errors.none?
  end

  private def add_uuid_to_new_record
    return unless @condition.new_record?
    @condition.uuid = SecureRandom.uuid
  end

  private def clear_unselected_label_fields
    if @params[:label_type].in?(%w[none provided])
      @params.delete(:label_attributes)
    end
    @params.delete(:label_id) if @params[:label_type] == 'custom'
    @params[:label_id] = nil if @params[:label_type] == 'none'
  end

  private def deactivate_current_csv
    # coerce to boolean, false is converted to null by ajax form refresh
    active = !!@params.delete(:current_csv_file_active)
    current_csv_file = @condition.current_tag_csv_file
    if current_csv_file
      current_csv_file.update(active: active)
      @condition.product_tags.destroy_all unless active
    end
  end

  private def save_csv_file
    @csv_file = @params[:csv_file]
    return unless @csv_file
    @condition.tag_csv_files.update_all(active: false)
    @condition.tag_csv_files.build(csv_file: @csv_file)
    @params.delete(:csv_file)
  end

  private def import_tags
    # users can only upload one file at a time
    return unless @csv_file.present?

    tag_importer = TagImporter.new(file: @csv_file, condition: @condition)
    ActiveRecord::Base.transaction do
      @condition.product_tags.destroy_all
      raise ActiveRecord::Rollback unless tag_importer.import
      @errors += tag_importer.errors
    end
  end
end
