# frozen_string_literal: true

# responsible for finding and formatting product data based on search params
class ProductFetcher
  # @param [ActionController::Parameters] params - params pertaining to which
  #   Products should be returned (and in which order). looks like this:
  #     {
  #       condition_identifier: the :uuid for the current Condition,
  #       selected_category_id: a Category id to find products within,
  #       selected_subcategory_id: a Subcategory id to find products within,
  #       selected_subsubcategory_id: a Subsubcategory id to find products
  #         within,
  #       selected_category_type: either 'tag' or 'category' - indicates if we
  #         should scope products to a category or tag
  #       search_term: a string that represents part of a Product name,
  #       search_type: either 'term' or 'category',
  #       sort_field <optional>: the :description of a ProductSortField that
  #         should be used for sorting,
  #       sort_direction <optional>: either 'asc' or 'desc',
  #       selected_filter_id: a tag id or subtag id to use for filtering,
  #       selected_filter_type: either 'tag' or 'subtag' - indicates how to
  #         filter products
  #     }
  #
  #   Notes:
  #     - the `search_type` param indicates whether products should be found by
  #       `search_term` or `subcategory_id`.
  #     - records should be sorted by the specified `sort_field` and
  #       `sort_direction` if present. otherwise, we use the condition's default
  #        sorting if present.
  def initialize(condition, params)
    @condition = condition
    @params = params
    @product_relation = Product.includes(product_suggestions: :add_on_product)
  end

  def fetch_products
    product_hashes = products.map do |product|
      ProductSerializer.new(product, @condition).serialize
    end
    ProductSorter.new(
      product_hashes,
      @condition,
      @params[:sort_field],
      @params[:sort_direction]
    ).sorted_products
  end

  private def products
    if @params[:search_type] == term_search_type
      scope_by_name
    else
      scope_by_membership
    end
    filter_products
    @product_relation.uniq
  end

  private def scope_by_name
    @product_relation = @product_relation.name_matches(@params[:search_term])
  end

  private def scope_by_membership
    case @params[:selected_category_type]
      when category_type
        scope_by_category
      when tag_type
        scope_by_tag
      else
        @product_relation = @product_relation.none
    end
  end

  private def scope_by_category
    if !@condition.show_products_by_subcategory
      criteria = { category_id: @params[:selected_category_id] }
    elsif @params[:selected_subsubcategory_id].present?
      criteria = { subsubcategory_id: @params[:selected_subsubcategory_id] }
    elsif @params[:selected_subcategory_id].present?
      criteria = { subcategory_id: @params[:selected_subcategory_id] }
    end
    @product_relation = @product_relation.where(criteria)
  end

  private def scope_by_tag
    if !@condition.show_products_by_subcategory
      @product_relation = @product_relation.with_tag(
        @params[:selected_category_id]
      )
    else
      @product_relation = @product_relation.with_subtag(
        @params[:selected_subcategory_id]
      )
    end
  end

  private def filter_products
    filter_by_excluded_subcategories
    filter_by_tag
  end

  private def filter_by_excluded_subcategories
    @product_relation = @product_relation.where.not(
      subcategory_id: @condition.excluded_subcategory_ids
    )
  end

  private def filter_by_tag
    # `tag_id` could actually be a Subtag's id - the `selected_filter_type`
    # param indicates if it is a tag or subtag id
    tag_id = @params[:selected_filter_id]
    return if tag_id.blank?

    if @params[:selected_filter_type] == subtag_type
      @product_relation = @product_relation.with_subtag(tag_id)
    else
      @product_relation = @product_relation.with_tag(tag_id)
    end
  end

  private def term_search_type
    'term'
  end

  private def category_type
    'category'
  end

  private def tag_type
    'tag'
  end

  private def subtag_type
    'subtag'
  end
end
