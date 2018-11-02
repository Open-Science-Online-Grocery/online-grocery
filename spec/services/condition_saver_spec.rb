# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConditionSaver do
  let(:condition) { Condition.new }

  subject { described_class.new(condition, params) }

  before do
    allow(condition).to receive(:save) { true }
  end

  context 'when condition is a new record' do
    let(:params) do
      { name: 'foo' }
    end

    it 'sets the uuid' do
      expect(condition.uuid).to be_nil
      expect(condition).to receive(:save)
      expect(subject.save_condition).to eq true
      expect(subject.errors).to be_empty
      expect(condition.uuid).not_to be_nil
    end

    context 'when saving fails' do
      before do
        allow(condition).to receive(:save) { false }
        allow(condition).to receive_message_chain(:errors, :full_messages) do
          ['an error!']
        end
      end

      it 'returns false and has errors' do
        expect(subject.save_condition).to eq false
        expect(subject.errors).to include 'an error!'
      end
    end
  end

  context 'when replacing a built-in label' do
    let(:params) do
      {
        label_id: 1,
        label_type: 'custom',
        label_attributes: { name: 'qqq' }
      }
    end

    it 'removes the label_id' do
      subject.save_condition
      expect(condition.label_id).to be_nil
    end
  end

  context 'when changing to no label' do
    let(:params) do
      {
        label_id: 1,
        label_type: 'none',
        label_attributes: { name: 'qqq' }
      }
    end

    it 'removes the label_id' do
      subject.save_condition
      expect(condition.label_id).to be_nil
    end
  end
end
