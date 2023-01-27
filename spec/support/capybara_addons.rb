# frozen_string_literal: true

# handy functions for capybara feature specs
module CapybaraAddons
  def add_to_cart(product_name)
    product_div = parent_of(
      parent_of(
        find('.product-card-name', text: product_name, exact_text: true)
      )
    )
    within(product_div) do
      force_click(find('.add-to-cart .submit'))
    end
  end

  def parent_of(element)
    element.first(:xpath, './/..')
  end

  def next_sibling_of(element)
    element.first(:xpath, 'following-sibling::*')
  end

  def force_click(element)
    script = 'arguments[0].click();'
    target = get_target(element)
    Capybara.current_session.driver.browser.execute_script(script, target)
  end

  def force_change(element)
    script = "arguments[0].click(); $(arguments[0]).trigger('change');"
    target = get_target(element)
    Capybara.current_session.driver.browser.execute_script(script, target)
  end

  def force_click_on(link_or_button_text)
    force_click(first('a, button', text: link_or_button_text))
  end

  def semantic_select(label_text, option_text)
    within(parent_of(find('label', text: label_text, exact_text: true))) do
      force_click find('.ui.selection.dropdown')
      force_click find('div.item', text: option_text, exact_text: true)
    end
  end

  def force_fill_input(element, value)
    script = <<-JS
      $(arguments[0]).attr('value',arguments[1]);
      $(arguments[0]).trigger('change');
    JS
    target = get_target(element)
    Capybara.current_session.driver.browser.execute_script(script, target, value)
  end

  def set_datepicker(label_text, datetime)
    label = find('label', text: label_text)
    input = find("##{label[:for]}")
    force_fill_input(input, datetime)
  end

  def expect_form_refresh
    auth_token = find('input[name="authenticity_token"]').value
    yield
    expect(page).not_to have_selector("input[value='#{auth_token}']")
  end

  private def get_target(element)
    return element.native if element.is_a?(Capybara::Node::Element)
    find(element).native
  end
end
