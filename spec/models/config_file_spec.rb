# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConfigFile do
  describe 'delegations' do
    it { is_expected.to delegate_method(:url).to(:file) }
    it { is_expected.to delegate_method(:current_path).to(:file) }
  end

  describe 'associations' do
    it { is_expected.to belong_to(:condition) }
  end

  describe '#name' do
    before do
      File.open('spec/support/apple_icon.png') do |f|
        subject.file = f
      end
    end

    it 'returns the basename of the file' do
      expect(subject.name).to eq 'apple_icon.png'
    end
  end
end
