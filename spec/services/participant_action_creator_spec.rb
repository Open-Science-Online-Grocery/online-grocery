# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantActionCreator do
  let(:condition) { build_stubbed(:condition) }
  let(:operation_attrs_1) do
    {
      session_id: 'abc123',
      type: 'add',
      product_id: 1,
      quantity: 2,
      serial_position: 3,
      id: 'some-uuid',
      performed_at: '2021-12-22 12:00:00 -0500'
    }
  end
  let(:operation_attrs_2) do
    {
      session_id: 'abc123',
      type: 'checkout',
      product_id: 1,
      quantity: 2,
      serial_position: 3,
      id: 'some-other-uuid',
      performed_at: '2021-12-22 12:01:00 -0500'
    }
  end
  let(:participant_action) { instance_double(ParticipantAction, save: true) }

  subject { described_class.new(condition, [operation_attrs_1, operation_attrs_2]) }

  before do
    allow(ParticipantAction).to receive(:new) { participant_action }
  end

  describe '#create_participant_actions' do
    context 'when creating actions succeeds' do
      it 'returns true and has no errors' do
        expect(subject.create_participant_actions).to be true
        expect(subject.errors).to be_empty
        expect(ParticipantAction).to have_received(:new).with(
          session_identifier: 'abc123',
          condition_id: condition.id,
          action_type: 'add',
          product_id: 1,
          quantity: 2,
          serial_position: 3,
          detail: nil,
          frontend_id: 'some-uuid',
          performed_at: Time.zone.parse('2021-12-22 12:00:00 -0500')
        )
        expect(ParticipantAction).to have_received(:new).with(
          session_identifier: 'abc123',
          condition_id: condition.id,
          action_type: 'checkout',
          product_id: 1,
          quantity: 2,
          serial_position: 3,
          detail: nil,
          frontend_id: 'some-other-uuid',
          performed_at: Time.zone.parse('2021-12-22 12:01:00 -0500')
        )
        expect(participant_action).to have_received(:save).twice
      end
    end

    context 'when creating actions fails' do
      let(:participant_action) { instance_double(ParticipantAction, save: false) }

      before do
        allow(participant_action).to receive_message_chain(:errors, :full_messages) do
          ['problem']
        end
      end

      it 'returns false and has errors' do
        expect(subject.create_participant_actions).to be false
        expect(subject.errors).to include 'problem'
      end
    end
  end
end
