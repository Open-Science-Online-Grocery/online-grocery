# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Setting custom nutrition label styling', :feature do
  let(:user) { create(:user) }
  let(:experiment) { create(:experiment, user: user) }
  let(:condition) { create(:condition, experiment: experiment) }

  before do
    sign_in user
    visit edit_experiment_condition_path(experiment, condition)
  end

  it 'allows nutrition label styling', :js do
    expect(page).to have_content 'Edit Condition'
    force_click(find('.item[data-tab="nutrition-facts"]'))

    expect(page).to have_content '8 servings per container'

    force_click(find('.nutrition-facts-title'))
    force_click(find_by_id('italic'))
    semantic_select('Font', 'Comic Sans MS')
    expect(find('.nutrition-facts-title').native.style('font-family')).to eq '"Comic Sans MS"'
    expect(find('.nutrition-facts-title').native.style('font-style')).to eq 'italic'

    force_click(find('.calories-label'))
    force_click(find_by_id('strikethrough'))
    expect(find('.calories-label').native.style('text-decoration')).to match 'line-through'

    expect_form_refresh do
      force_click(first('label', text: 'Use this styling only for products that match the following calculation:'))
    end

    within('[data-tab="nutrition-facts"] div.calculator') do
      force_click find('.ui.selection.dropdown')
      force_click find('div.item', text: 'Calories per serving', exact_text: true)
      force_click_on('Insert field')

      force_click_on('>')
      force_click_on('5')
      force_click_on('0')
      force_click_on('0')
    end

    force_click_on 'Save'

    expect(page).to have_content 'Condition successfully updated'

    expect(find('.nutrition-facts-title').native.style('font-family')).to eq '"Comic Sans MS"'
    expect(find('.nutrition-facts-title').native.style('font-style')).to eq 'italic'
    expect(find('.calories-label').native.style('text-decoration')).to match 'line-through'

    within('[data-tab="nutrition-facts"] .equation-editor') do
      expect(page).to have_content 'Calories per serving>500'
    end

    force_click(find('.nutrition-facts-title'))
    force_click_on('Current Selection')
    expect(find('.nutrition-facts-title').native.style('font-family')).not_to eq '"Comic Sans MS"'
    expect(find('.nutrition-facts-title').native.style('font-style')).not_to eq 'italic'
  end
end
