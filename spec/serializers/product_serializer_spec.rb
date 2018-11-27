# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSerializer do
  let(:product) do
    instance_double('Product', attributes: { 'foo' => 'bar' })
  end
  let(:condition) do
    instance_double(
      'Condition',
      label_equation: label_equation,
      label_image_url: 'foo.jpg',
      label_position: 'bottom right',
      label_size: 20,
      style_use_type: style_use_type,
      nutrition_equation: nutrition_equation,
      style_use_types: Condition.style_use_types,
      nutrition_styles: 'some styles'
    )
  end
  let(:label_equation) do
    instance_double('Equation', evaluate: label_applies)
  end
  let(:label_applies) { false }
  let(:style_use_type) { 'calculation' }
  let(:nutrition_equation) do
    instance_double('Equation', evaluate: nutrition_equation_applies)
  end
  let(:nutrition_equation_applies) { false }

  subject { described_class.new(product, condition) }

  context 'when label attributes should not be included' do
    it 'returns only the product\'s attributes' do
      expected_output = { 'foo' => 'bar' }
      expect(subject.serialize).to eq expected_output
    end
  end

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

  context 'when condition always uses nutrition styling' do
    let(:style_use_type) { 'always' }

    it 'returns the product\'s attributes plus the nutrition styles' do
      expected_output = {
        'foo' => 'bar',
        'nutrition_style_rules' => 'some styles'
      }
      expect(subject.serialize).to eq expected_output
    end
  end

  context 'when condition applies nutrition styling via calculation' do
    context 'when calculation does not apply' do
      it 'returns only the product\'s attributes' do
        expected_output = { 'foo' => 'bar' }
        expect(subject.serialize).to eq expected_output
      end
    end

    context 'when calculation applies' do
      let(:nutrition_equation_applies) { true }

      it 'returns the product\'s attributes plus the nutrition styles' do
        expected_output = {
          'foo' => 'bar',
          'nutrition_style_rules' => 'some styles'
        }
        expect(subject.serialize).to eq expected_output
      end
    end
  end
end
