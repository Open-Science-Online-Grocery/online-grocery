# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Paginator do
  context 'with full pages of records' do
    let(:records) { (1..400).to_a }

    context 'when requesting the first page' do
      subject { described_class.new(records, 1) }

      it 'returns the expected records' do
        expect(subject.records).to eq (1..100).to_a
        expect(subject.total_pages).to eq 4
      end
    end

    context 'when requesting the last page' do
      subject { described_class.new(records, 4) }

      it 'returns the expected records' do
        expect(subject.records).to eq (301..400).to_a
        expect(subject.total_pages).to eq 4
      end
    end
  end

  context 'when the last page is not full' do
    let(:records) { (1..405).to_a }

    context 'when requesting the first page' do
      subject { described_class.new(records, 1) }

      it 'returns the expected records' do
        expect(subject.records).to eq (1..100).to_a
        expect(subject.total_pages).to eq 5
      end
    end

    context 'when requesting the last page' do
      subject { described_class.new(records, 5) }

      it 'returns the expected records' do
        expect(subject.records).to eq (401..405).to_a
        expect(subject.total_pages).to eq 5
      end
    end
  end
end
