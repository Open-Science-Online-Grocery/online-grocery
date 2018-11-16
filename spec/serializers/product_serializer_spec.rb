# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSerializer do
  let(:product) do
    instance_double('Product', attributes: { 'foo' => 'bar' })
  end
  let(:condition) do
    instance_double(
      'Condition',
      label_equation: equation,
      label_image_url: 'foo.jpg',
      label_position: 'bottom right',
      label_size: 20
    )
  end
  let(:equation) do
    instance_double('Equation', evaluate_with_product: label_applies)
  end

  subject { described_class.new(product, condition) }

  context 'when label attributes should be included' do
    let(:label_applies) { true }

    it 'returns the product\'s attributes plus the label attributes' do
      expected_output = {
        'foo' => 'bar',
        'label_image_url' => 'foo.jpg',
        'label_position' => 'bottom right',
        'label_size' => 20
      }
      expect(subject.serialize).to eq expected_output
    end
  end

  context 'when label attributes should not be included' do
    let(:label_applies) { false }

    it 'returns only the product\'s attributes' do
      expected_output = { 'foo' => 'bar' }
      expect(subject.serialize).to eq expected_output
    end
  end
end
