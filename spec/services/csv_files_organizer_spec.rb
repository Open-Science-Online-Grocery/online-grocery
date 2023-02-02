# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CsvFilesOrganizer do
  let(:filename) { 'testfile.csv' }
  let(:condition) { build(:condition) }
  let(:csv_generator_class) { CsvFileManagers::Category }
  let(:file) { instance_double(File, write: true, path: 'filepath') }

  subject do
    described_class.new(
      filename,
      csv_generator_class,
      condition
    )
  end

  before do
    allow(Time).to receive_message_chain(:zone, :today) { 'time' }
    allow(File).to receive(:new) { file }
    allow(csv_generator_class).to receive(:generate_csv) { true }
  end

  describe '#handle_csv_file' do
    context 'when the csv file does not exist on the tmp folder' do
      it 'creates a new file and returns its data' do
        expect(subject.handle_csv_file).to eql('filepath')
        expect(File).to have_received(:new).with(
          Rails.root.join('tmp/testfile.csv'),
          'w'
        )
      end
    end

    context 'when the csv file exist on the tmp folder' do
      before do
        allow(subject).to receive(:search_existing_file) { 'testfile.csv' }
      end

      it 'finds the file and returns its data' do
        expect(subject.handle_csv_file).to eql(Rails.root.join('tmp/testfile.csv').to_s)
        expect(File).not_to have_received(:new).with(
          Rails.root.join('tmp/testfile.csv'),
          'w'
        )
      end
    end
  end
end
