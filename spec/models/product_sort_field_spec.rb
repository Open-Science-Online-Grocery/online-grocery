# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSortField, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_uniqueness_of :name }
    it { is_expected.to validate_uniqueness_of :description }
  end

  describe '#incomplete_data?' do
    before do
      allow(Product).to receive(:where).with(calories: nil).and_return([])
      allow(Product).to receive(:where).with(total_fat: nil).and_return(['x'])
    end

    context 'when not a product variable' do
      subject { described_class.new(name: 'foo') }

      it 'returns false' do
        expect(subject.incomplete_data?).to eq false
      end
    end

    context 'when a product variable' do
      context 'when there are no records with nil data' do
        subject { described_class.new(name: 'calories') }

        it 'returns false' do
          expect(subject.incomplete_data?).to eq false
        end
      end

      context 'when there are records with nil data' do
        subject { described_class.new(name: 'total_fat') }

        it 'returns true' do
          expect(subject.incomplete_data?).to eq true
        end
      end
    end
  end
end
