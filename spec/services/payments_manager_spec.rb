# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PaymentsManager do
  let(:user) { build(:user) }
  let(:paypal_subscription_id) { '1234' }
  let(:subscription) { instance_double(Subscription, needs_to_pay?: false, perpetual_membership: false) }

  subject do
    described_class.new(
      user
    )
  end

  before do
    allow(Time).to receive_message_chain(:zone, :now) { 'time' }
    allow(Time).to receive_message_chain(:zone, :today) { 'time' }
    allow(Subscription).to receive(:new) { subscription }

    allow(user).to receive(:save) { true }
    allow(user).to receive(:subscription=) { true }
    allow(user).to receive(:subscription) { subscription }
    allow(user).to receive(:needs_subscription?) { true }
    allow(subject).to receive(:request_subscription_info) { { 'status' => 'ACTIVE' } }
  end

  describe '#create_subscription' do
    context 'when there are no errors' do
      it 'creates a subscription and returns true' do
        expect(subject.create_subscription(paypal_subscription_id)).to eql(true)
        expect(subject.errors).to be_empty
        expect(Subscription).to have_received(:new).with(
          {
            paypal_subscription_id: '1234',
            start_date: 'time'
          }
        )
        expect(user).to have_received(:needs_subscription?)
        expect(subject).to have_received(:request_subscription_info)
      end
    end

    context 'when there are an error' do
      before do
        allow(Subscription).to receive(:new) { subscription }

        allow(user).to receive(:save) { false }
        allow(user).to receive(:errors) { ['ouch'] }
        allow(user).to receive(:subscription=) { true }
        allow(user).to receive(:needs_subscription?) { true }
      end

      it 'does not create a subscription and returns false' do
        expect(subject.create_subscription(paypal_subscription_id)).to eql(false)
        expect(subject.errors).to include 'ouch'
        expect(Subscription).to have_received(:new).with(
          {
            paypal_subscription_id: '1234',
            start_date: 'time'
          }
        )
        expect(user).not_to have_received(:needs_subscription?)
        expect(subject).not_to have_received(:request_subscription_info)
      end
    end
  end
end
