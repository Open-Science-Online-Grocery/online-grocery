# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSerializer do
  let(:product) do
    instance_double('Product', attributes: { 'foo' => 'bar' })
  end
  let(:condition_label_1) do
    instance_double(
      'ConditionLabel',
      position: 'bottom right',
      size: 20,
      equation: label_equation_1,
      image_url: 'foo.jpg'
    )
  end
  let(:condition_label_2) do
    instance_double(
      'ConditionLabel',
      position: 'top left',
      size: 25,
      equation: label_equation_2,
      image_url: 'bar.jpg'
    )
  end
  let(:condition) do
    instance_double(
      'Condition',
      condition_labels: [condition_label_1, condition_label_2],
      style_use_type: style_use_type,
      nutrition_equation: nutrition_equation,
      style_use_types: Condition.style_use_types,
      nutrition_styles: 'some styles'
    )
  end
  let(:label_equation_1) do
    instance_double('Equations::Label', evaluate: label_1_applies)
  end
  let(:label_equation_2) do
    instance_double('Equations::Label', evaluate: label_2_applies)
  end
  let(:label_1_applies) { true }
  let(:label_2_applies) { true }
  let(:style_use_type) { 'calculation' }
  let(:nutrition_equation) do
    instance_double('Equations::Nutrition', evaluate: nutrition_equation_applies)
  end
  let(:nutrition_equation_applies) { false }

  subject { described_class.new(product, condition) }

  describe 'label attributes' do
    context 'when no labels apply to the product' do
      let(:label_1_applies) { false }
      let(:label_2_applies) { false }

      it 'returns the product\'s attributes and an empty labels array' do
        expected_output = { 'foo' => 'bar', labels: [] }
        expect(subject.serialize).to eq expected_output
      end
    end

    context 'when one label applies to the product' do
      let(:label_2_applies) { false }

      it 'returns the product\'s attributes plus the applicable label attributes' do
        expected_output = {
          'foo' => 'bar',
          labels: [
            {
              'label_image_url' => 'foo.jpg',
              'label_position' => 'bottom right',
              'label_size' => 20
            }
          ]
        }
        expect(subject.serialize).to eq expected_output
      end
    end

    context 'when multiple labels apply to the product' do
      it 'returns the product\'s attributes plus the applicable labels attributes' do
        expected_output = {
          'foo' => 'bar',
          labels: [
            {
              'label_image_url' => 'foo.jpg',
              'label_position' => 'bottom right',
              'label_size' => 20
            },
            {
              'label_image_url' => 'bar.jpg',
              'label_position' => 'top left',
              'label_size' => 25
            }
          ]
        }
        expect(subject.serialize).to eq expected_output
      end
    end
  end

  describe 'nutrition styling' do
    let(:label_1_applies) { false }
    let(:label_2_applies) { false }

    context 'when condition always uses nutrition styling' do
      let(:style_use_type) { 'always' }

      it 'returns the product\'s attributes plus the nutrition styles' do
        expected_output = {
          'foo' => 'bar',
          'nutrition_style_rules' => 'some styles',
          labels: []
        }
        expect(subject.serialize).to eq expected_output
      end
    end

    context 'when condition applies nutrition styling via calculation' do
      context 'when calculation does not apply' do
        it 'returns only the product\'s attributes' do
          expected_output = { 'foo' => 'bar', labels: [] }
          expect(subject.serialize).to eq expected_output
        end
      end

      context 'when calculation applies' do
        let(:nutrition_equation_applies) { true }

        it 'returns the product\'s attributes plus the nutrition styles' do
          expected_output = {
            'foo' => 'bar',
            'nutrition_style_rules' => 'some styles',
            labels: []
          }
          expect(subject.serialize).to eq expected_output
        end
      end
    end
  end
end
