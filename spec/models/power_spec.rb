# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Power do
  let(:request) do
    instance_double(
      'ActionDispatch::Request',
      params: { action: 'foo', controller: 'bar' }
    )
  end

  subject { described_class.new(@user, request: request) }

  before(:all) do
    @user = create(:user)
    @own_experiment = create(:experiment, user: @user)
    @own_condition = create(:condition, experiment: @own_experiment)
    @own_sort_file = create(:sort_file, condition: @own_condition)

    @other_experiment = create(:experiment)
    @other_condition = create(:condition, experiment: @other_experiment)
    @other_sort_file = create(:sort_file, condition: @other_condition)
  end

  after(:all) do
    clean_with_deletion
  end

  describe '#own_experiments' do
    it 'includes the expected records' do
      expect(subject.own_experiments).to include @own_experiment
      expect(subject.own_experiments).not_to include @other_experiment
    end
  end

  describe '#manageable_conditions' do
    it 'includes the expected records' do
      expect(subject.manageable_conditions).to include @own_condition
      expect(subject.manageable_conditions).not_to include @other_condition
    end
  end

  describe '#downloadable_config_files' do
    it 'includes the expected records' do
      expect(subject.downloadable_config_files).to include @own_sort_file
      expect(subject.downloadable_config_files).not_to include @other_sort_file
    end
  end

  describe '#no_fallback' do
    it 'raises an UncheckedPower exception' do
      expect { subject.no_fallback }.to raise_error(Consul::UncheckedPower)
    end
  end
end
