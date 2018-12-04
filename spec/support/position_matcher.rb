# frozen_string_literal: true

RSpec::Matchers.define :appear_before do |later_content|
  match do |earlier_content|
    expect(page).to have_content earlier_content
    expect(page).to have_content later_content
    expect(page.body).to match(/#{earlier_content}.*#{later_content}/)
  end
end
