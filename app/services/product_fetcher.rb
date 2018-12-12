# frozen_string_literal: true

# responsible for finding and formatting product data based on search params
class ProductFetcher
  # @param [ActionController::Parameters] params - params pertaining to which
  #   Products should be returned (and in which order). looks like this:
  #     {
  #       condition_identifier: the :uuid for the current Condition,
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
    products = Product.none
    if @params[:search_type] == term_search_type
      products = Product.name_matches(@params[:search_term])
    else
      products = products_from_category
    end
    filtered_products(products)
  end

  private def products_from_category
    case @params[:selected_category_type]
    when category_type
      products_scoped_by_category
    when tag_type
      Product.joins(:product_tags).where(
        product_tags: { subtag_id: @params[:selected_subcategory_id] }
      )
    else
      Product.none
    end
  end

  private def products_scoped_by_category
    if @params[:selected_subsubcategory_id].present?
      Product.where(
        subcategory_id: @params[:selected_subcategory_id],
        subsubcategory_id: @params[:selected_subsubcategory_id]
      )
    else
      Product.where(subcategory_id: @params[:selected_subcategory_id])
    end
  end

  private def filtered_products(products)
    # `tag_id` could actually be a Subtag's id - the `selected_filter_type`
    # param indicates if it is a tag or subtag id
    tag_id = @params[:selected_filter_id]
    return products unless tag_id.present?
    if @params[:selected_filter_type] == subtag_type
      return products.with_subtag(tag_id)
    end
    products.with_tag(tag_id)
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
