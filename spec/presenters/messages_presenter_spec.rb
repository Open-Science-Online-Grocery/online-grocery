# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MessagesPresenter do
  describe '#show_messages' do
    let(:flash) { { error: 'Error' } }
    let(:messages) { {} }

    subject { described_class.new(flash.with_indifferent_access, messages) }

    context 'when @messages is empty' do
      context 'when the flash key is in the expected list' do
        it 'returns a div whose class is dependent upon the flash key' do
          flash_message = subject.show_messages

          expect(flash_message).to match(/<div.+<\/div>/)
          expect(flash_message).to match 'class="ui message error"'
        end
      end

      context 'when the flash key is not in the expected list' do
        let(:flash) { { foo: 'bar' } }

        it 'returns an empty wrapper div' do
          expect(subject.show_messages).to eq '<div data-flash="true" class="flash"></div>'
        end
      end

      context 'when the flash contains an array' do
        let(:flash) { { error: ['first error', 'second error'] } }

        it 'returns a list nested within the flash div' do
          flash_message = subject.show_messages

          expect(flash_message).to match(/<ul.+<\/ul>/)
          expect(flash_message).to include '<li>first error</li>'
          expect(flash_message).to include '<li>second error</li>'
        end
      end

      context 'when the flash contains a hash' do
        let(:flash) do
          { error: { header: 'HEADER', messages: ['first error', 'second error'] } }
        end

        it 'returns a list nested within the flash div with a header' do
          flash_message = subject.show_messages

          expect(flash_message).to include '<div class="header">HEADER:</div>'
          expect(flash_message).to match(/<ul.+<\/ul>/)
          expect(flash_message).to include '<li>first error</li>'
          expect(flash_message).to include '<li>second error</li>'
        end
      end

      context 'when the flash contains a string' do
        let(:flash) { { error: 'My error' } }

        it 'adds the string to the content of the flash div' do
          flash_message = subject.show_messages

          expect(flash_message).to eq(
            '<div data-flash="true" class="flash"><div class="ui message error">My error</div></div>'
          )
        end
      end
    end

    context 'when @messages has a different key' do
      let(:messages) { { success: 'Success!' } }

      it 'returns a div for each key' do
        flash_message = subject.show_messages
        expect(flash_message).to match(
          '<div class="ui message error">Error</div>'
        )
        expect(flash_message).to match(
          '<div class="ui message success">Success!</div>'
        )
      end
    end

    context 'when @messages has the same key' do
      context 'when both values are strings' do
        let(:messages) { { error: 'Another error!' } }

        it 'shows both' do
          flash_message = subject.show_messages

          expect(flash_message).to match '<div class="ui message error">Error</div>'
          expect(flash_message).to match '<div class="ui message error">Another error!</div>'
        end
      end

      context 'when both values are arrays' do
        let(:flash) { { error: ['Error'] } }
        let(:messages) { { error: ['Another error!'] } }

        it 'shows both' do
          flash_message = subject.show_messages

          expect(flash_message).to match '<div class="ui message error"><ul><li>Error</li></ul></div>'
          expect(flash_message).to match '<div class="ui message error"><ul><li>Another error!</li></ul></div>'
        end
      end

      context 'when one is a string and the other is a hash' do
        let(:flash) { { error: 'Error' } }
        let(:messages) do
          {
            error: {
              header: 'hello',
              messages: ['error 1', 'error 2']
            }
          }
        end

        it 'shows both' do
          flash_message = subject.show_messages

          expect(flash_message).to match '<div class="ui message error">Error</div>'
          expect(flash_message).to match '<div class="ui message error"><div class="header">hello:</div><ul><li>error 1</li><li>error 2</li></ul></div>'
        end
      end
    end
  end
end
