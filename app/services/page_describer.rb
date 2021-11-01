# frozen_string_literal: true

# responsible for turning info from the state of the grocery store redux app
# into a human-readable description of the page a user has viewed
class PageDescriber
  def initialize(params)
    @params = params
  end

  def description
    if @params[:search_type] == ProductFetcher.term_search_type
      "Search results: \"#{@params[:search_term]}\""
    else
      membership_description
    end
  end

  private def membership_description
    case @params[:selected_category_type]
      when ProductFetcher.category_type
        describe_by_category
      when ProductFetcher.tag_type
        describe_by_tag
    end
  end

  private def describe_by_category
    if @params[:selected_subsubcategory_id].present?
      subsubcategory = Subsubcategory.find(@params[:selected_subsubcategory_id])
      "Subsubcategory: #{subsubcategory}"
    elsif @params[:selected_subcategory_id].present?
      subcategory = Subcategory.find(@params[:selected_subcategory_id])
      "Subcategory: #{subcategory}"
    else
      category = Category.find(@params[:selected_category_id])
      "Category: #{category}"
    end
  end

  # NOTE: while they are internally called "tags" and "subtags", the users
  # know them as custom categories/subcategories
  private def describe_by_tag
    if @params[:selected_subcategory_id].present?
      subtag = Subtag.find(@params[:selected_subcategory_id])
      "Custom Subcategory: #{subtag}"
    else
      tag = Tag.find(@params[:selected_category_id])
      "Custom Category: #{tag}"
    end
  end
end
