# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ParticipantActionsExporter do
  let(:result_1) do
    instance_double(
      'ExperimentResult',
      experiment_id: 1,
      experiment_name: 'The Best Experiment',
      condition_name: 'Control Condition',
      session_identifier: 'asdf',
      action_type: 'view',
      product_name: 'Daves Killer Bread Bread, Organic, 21 Whole Grains and Seeds',
      quantity: nil,
      created_at: Time.zone.parse('2018-11-15 14:00:00')
    )
  end
  let(:result_2) do
    instance_double(
      'ExperimentResult',
      experiment_id: 1,
      experiment_name: 'The Best Experiment',
      condition_name: 'Control Condition',
      session_identifier: 'asdf',
      action_type: 'add',
      product_name: 'Daves Killer Bread Bread, Organic, 21 Whole Grains and Seeds',
      quantity: 3,
      created_at: Time.zone.parse('2018-11-15 14:01:00')
    )
  end
  let(:experiment) do
    instance_double(
      'Experiment',
      experiment_results: [result_1, result_2]
    )
  end
  let(:expected_output) do
    <<~CSV
      Experiment Name,Condition Name,Session Identifier,Participant Action Type,Product Name,Quantity,Participant Action Date/Time
      The Best Experiment,Control Condition,asdf,view,"Daves Killer Bread Bread, Organic, 21 Whole Grains and Seeds",,11/15/2018 2:00 PM EST
      The Best Experiment,Control Condition,asdf,add,"Daves Killer Bread Bread, Organic, 21 Whole Grains and Seeds",3,11/15/2018 2:01 PM EST
    CSV
  end

  subject { described_class.new(experiment) }

  describe '#generate_csv' do
    it 'returns the expected data' do
      expect(subject.generate_csv).to eq expected_output
    end
  end
end