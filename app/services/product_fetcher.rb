# frozen_string_literal: true

# responsible for finding and formatting product data based on search params
class ProductFetcher
  # @param [ActionController::Parameters] params - params pertaining to which
  #   Products should be returned (and in which order). looks like this:
  #     {
  #       search_type: either 'term' or 'category',
  #       search_term: a string that represents part of a Product name,
  #       subcategory_id: a Subcategory id to find products within,
  #       condition_identifier: the :uuid for the current Condition,
  #       sort_field <optional>: the :description of a ProductSortField that
  #         should be used for sorting,
  #       sort_direction <optional>: either 'asc' or 'desc'
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
    category_id = @params[:selected_category_id]
    subcategory_id = @params[:selected_subcategory_id]
    case @params[:selected_category_type]
    when category_type
      Product.where(subcategory_id: subcategory_id)
    when tag_type
      Product.joins(:product_tags).where(
        product_tags: {
          tag_id: category_id,
          subtag_id: subcategory_id
        }
      )
    else
      Product.none
    end
  end

  private def filtered_products(products)
    subtag_id = @params[:selected_filter_id]
    return products unless subtag_id.present?
    products.with_subtag(subtag_id)
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
end
