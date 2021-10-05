# frozen_string_literal: true

class ConditionsController < ApplicationController
  power :conditions, context: :set_experiment, map: {
    %i[refresh_form new create edit update destroy] => :own_experiment
  }

  before_action :set_condition
  before_action :set_breadcrumbs
  before_action :set_tab

  def refresh_form
    manager = ConditionManager.new(@condition, condition_params)
    manager.assign_params
    render @condition.id? ? 'edit' : 'new'
  end

  def new
    @resource_name = 'Add Condition'
  end

  def create
    manager = ConditionManager.new(@condition, condition_params)
    if manager.update_condition
      flash[:success] = 'Condition successfully created'
      redirect_to edit_experiment_condition_path(
        @experiment,
        @condition,
        tab: @tab
      )
    else
      set_condition_errors(manager)
      @resource_name = 'Add Condition'
      render :new
    end
  end

  def edit
    @resource_name = "Condition: #{@condition.name}"
  end

  def update
    manager = ConditionManager.new(@condition, condition_params)
    if manager.update_condition
      flash[:success] = 'Condition successfully updated'
      redirect_to edit_experiment_condition_path(
        @experiment,
        @condition,
        tab: @tab
      )
    else
      set_condition_errors(manager)
      @resource_name = "Condition: #{@condition.name}"
      render :edit
    end
  end

  def destroy
    if @condition.destroy
      flash[:success] = 'Condition successfully deleted'
    else
      set_error_messages(@condition)
    end
    redirect_to experiment_path(@experiment)
  end

  private def set_condition
    if params[:id].present?
      condition = Condition.find(params[:id])
    else
      condition = @experiment.conditions.build(
        sort_type: Condition.sort_types.none
      )
    end
    @condition = ConditionPresenter.new(condition)
  end

  # rubocop:disable Metrics/MethodLength
  private def condition_params
    params.require(:condition).permit(
      :id,
      :name,
      :qualtrics_code,
      :sort_type,
      :default_sort_field_id,
      :default_sort_order,
      :sort_equation_tokens,
      :only_add_from_detail_page,
      :nutrition_styles,
      :filter_by_custom_categories,
      :show_food_count,
      :show_price_total,
      :food_count_format,
      :style_use_type,
      :nutrition_equation_tokens,
      :may_add_to_cart_by_dollar_amount,
      :minimum_spend,
      :maximum_spend,
      :show_guiding_stars,
      :new_tag_csv_file,
      :new_suggestion_csv_file,
      :show_products_by_subcategory,
      tag_csv_files_attributes: %i[id active],
      suggestion_csv_files_attributes: %i[id active],
      product_sort_field_ids: [],
      included_category_ids: [],
      included_subcategory_ids: [],
      condition_labels_attributes: [
        :id,
        :_destroy,
        :label_id,
        :label_type,
        :position,
        :size,
        :tooltip_text,
        :equation_tokens,
        :always_show,
        label_attributes: %i[id image image_cache name built_in]
      ],
      condition_cart_summary_labels_attributes: [
        :id,
        :_destroy,
        :cart_summary_label_id,
        :label_type,
        :equation_tokens,
        :always_show,
        cart_summary_label_attributes: %i[id image image_cache name built_in]
      ]
    )
  end
  # rubocop:enable Metrics/MethodLength

  private def set_breadcrumbs
    @breadcrumbs = [
      OpenStruct.new(name: @experiment.name, path: experiment_path(@experiment))
    ]
  end

  private def set_tab
    @tab = params[:tab] || 'basic-info'
  end

  private def set_experiment
    @experiment = Experiment.find(params[:experiment_id])
  end

  private def set_condition_errors(manager)
    @messages = {
      error: {
        header: 'Unable to save condition',
        messages: manager.errors
      }
    }
  end
end
