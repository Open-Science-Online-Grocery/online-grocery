# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProductSerializer do
  let(:product) do
    instance_double(
      'Product',
      attributes: { 'foo' => 'bar' },
      add_on_product: false,
      custom_attribute_amount: nil
    )
  end
  let(:condition_label_1) do
    instance_double(
      'ConditionLabel',
      position: 'bottom right',
      size: 20,
      equation: label_equation_1,
      image_url: 'foo.jpg',
      name: 'foo label',
      tooltip_text: 'hello',
      below_button?: true
    )
  end
  let(:condition_label_2) do
    instance_double(
      'ConditionLabel',
      position: 'top left',
      size: 25,
      equation: label_equation_2,
      image_url: 'bar.jpg',
      name: 'bar label',
      tooltip_text: 'goodbye',
      below_button?: false
    )
  end
  let(:condition) do
    instance_double(
      'Condition',
      condition_labels: [condition_label_1, condition_label_2],
      style_use_type: style_use_type,
      nutrition_equation: nutrition_equation,
      style_use_types: Condition.style_use_types,
      nutrition_styles: 'some styles',
      custom_attribute_name: 'attr_name',
      custom_attribute_units: 'attr_unit',
      show_custom_attribute_on_product: false,
      show_custom_attribute_on_checkout: true
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

      describe '#serialize' do
        it 'returns the product\'s attributes and an empty labels array' do
          expected_output = { 'foo' => 'bar', labels: [] }
          expect(subject.serialize).to eq expected_output
        end
      end

      describe '#label_sort' do
        it 'returns the expected value' do
          expect(subject.label_sort).to eq 0
        end
      end
    end

    context 'when one label applies to the product' do
      let(:label_2_applies) { false }

      describe '#serialize' do
        it 'returns the product\'s attributes plus the applicable label attributes' do
          expected_output = {
            'foo' => 'bar',
            labels: [
              {

                'label_name' => 'foo label',
                'label_image_url' => 'foo.jpg',
                'label_position' => 'bottom right',
                'label_size' => 20,
                'label_tooltip' => 'hello',
                'label_below_button' => true
              }
            ]
          }
          expect(subject.serialize).to eq expected_output
        end
      end

      describe '#label_sort' do
        it 'returns the expected value' do
          expect(subject.label_sort).to eq(-1)
        end
      end
    end

    context 'when multiple labels apply to the product' do
      describe '#serialize' do
        it 'returns the product\'s attributes plus the applicable labels attributes' do
          expected_output = {
            'foo' => 'bar',
            labels: [
              {
                'label_name' => 'foo label',
                'label_image_url' => 'foo.jpg',
                'label_position' => 'bottom right',
                'label_size' => 20,
                'label_tooltip' => 'hello',
                'label_below_button' => true
              },
              {
                'label_name' => 'bar label',
                'label_image_url' => 'bar.jpg',
                'label_position' => 'top left',
                'label_size' => 25,
                'label_tooltip' => 'goodbye',
                'label_below_button' => false
              }
            ]
          }
          expect(subject.serialize).to eq expected_output
        end
      end

      describe '#label_sort' do
        it 'returns the expected value' do
          expect(subject.label_sort).to eq(-2)
        end
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

  describe 'custom product attributes' do
    context 'when the product does not have custom attributes' do
      describe '#serialize' do
        it 'returns the product\'s attributes without the custom attributes field' do
          expect(subject.serialize).not_to have_key(:custom_attribute)
        end
      end
    end

    context 'when the user unchecked both the options to display' do
      let(:product) do
        instance_double(
          'Product',
          attributes: { 'foo' => 'bar' },
          add_on_product: false,
          custom_attribute_amount: 12
        )
      end
      let(:condition) do
        instance_double(
          'Condition',
          condition_labels: [condition_label_1, condition_label_2],
          style_use_type: style_use_type,
          nutrition_equation: nutrition_equation,
          style_use_types: Condition.style_use_types,
          nutrition_styles: 'some styles',
          show_custom_attribute_on_product: false,
          show_custom_attribute_on_checkout: false
        )
      end

      describe '#serialize' do
        it 'returns the product\'s attributes without the custom attributes field' do
          expect(subject.serialize).not_to have_key(:custom_attribute)
        end
      end
    end

    context 'when the product have custom attributes' do
      let(:product) do
        instance_double(
          'Product',
          attributes: { 'foo' => 'bar' },
          add_on_product: false,
          custom_attribute_amount: 12
        )
      end
      let(:label_1_applies) { false }
      let(:label_2_applies) { false }

      describe '#serialize' do
        it 'returns the product\'s attributes with the custom attributes field' do
          expected_output = {
            'foo' => 'bar',
            labels: [],
            custom_attribute: {
              'custom_attribute_unit' => 'attr_unit',
              'custom_attribute_name' => 'attr_name',
              'custom_attribute_amount' => 12,
              'display_on_detail' => false,
              'display_on_checkout' => true
            }
          }
          expect(subject.serialize).to eql(expected_output)
        end
      end
    end
  end

  describe 'add-on attributes' do
    let(:condition) { NullCondition.new }

    context 'with no add-on product' do
      it 'does not include it in the hash' do
        expected_output = {
          'foo' => 'bar',
          'nutrition_style_rules' => '{}',
          labels: []
        }
        expect(subject.serialize).to eq expected_output
      end
    end

    context 'with an add-on product' do
      let(:add_on_product) do
        instance_double('Product', attributes: { 'baz' => 'qux' }, custom_attribute_amount: nil)
      end

      before do
        allow(product).to receive(:add_on_product) { add_on_product }
      end

      context 'when add-on info should be included' do
        it 'includes it in the hash' do
          expected_output = {
            'foo' => 'bar',
            'nutrition_style_rules' => '{}',
            labels: [],
            'add_on' => {
              'baz' => 'qux',
              'nutrition_style_rules' => '{}',
              labels: []
            }
          }
          expect(subject.serialize).to eq expected_output
          expect(product).to have_received(:add_on_product).with(condition)
        end
      end

      context 'when add-on info should not be included' do
        it 'does not include it in the hash' do
          expected_output = {
            'foo' => 'bar',
            'nutrition_style_rules' => '{}',
            labels: []
          }
          expect(subject.serialize(include_add_on: false)).to eq expected_output
        end
      end
    end
  end
end
