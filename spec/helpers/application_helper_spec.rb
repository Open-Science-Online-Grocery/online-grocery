# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper do
  describe '#application_version' do
    before { stub_const('APP_VERSION', major: 1, minor: 2, revision: 3) }

    context 'when a release candidate is not present in the version' do
      it 'returns a string containing the major, minor and version numbers' do
        version = helper.application_version

        expect(version).to eq '1.2.3'
      end
    end

    context 'when a release candidate is present in the version' do
      before do
        stub_const(
          'APP_VERSION',
          major: 1, minor: 2, revision: 3, release_candidate: 4
        )
      end

      it 'returns a string containing the major, minor, revision and release candidate numbers' do
        expect(helper.application_version).to eq '1.2.3.rc-4'
      end
    end

    context 'when the APP_VERSION is not set' do
      before { stub_const('APP_VERSION', nil) }

      it 'returns an empty string' do
        expect(helper.application_version).to eq ''
      end
    end
  end
end
