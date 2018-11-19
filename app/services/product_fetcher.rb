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
  def initialize(params)
    @params = params
  end

  def fetch_products
    product_hashes = products.map do |product|
      ProductSerializer.new(product, condition).serialize
    end
    ProductSorter.new(
      product_hashes,
      condition,
      @params[:sort_field],
      @params[:sort_direction]
    ).sorted_products
  end

  private def products
    if @params[:search_type] == term_search_type
      return Product.name_matches(@params[:search_term])
    end

    category_id = @params[:selected_category_id]
    subcategory_id = @params[:selected_subcategory_id]
    case @params[:selected_category_type]
    when 'category'
      Product.where(subcategory_id: subcategory_id)
    when 'tag'
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

  private def condition
    @condition ||= Condition.find_by(uuid: @params[:condition_identifier])
  end

  private def term_search_type
    'term'
  end
end
