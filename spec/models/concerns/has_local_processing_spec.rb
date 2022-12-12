# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bulkrax::HasLocalProcessing do
  let(:entry) { build(:bulkrax_csv_entry) }

  describe '#add_local' do
    it 'calls #add_controlled_fields' do
      expect(entry).to receive(:add_controlled_fields)
      entry.add_local
    end

    describe '#add_controlled_fields' do
      describe 'sanitizing user-provided URI values' do
        context 'when value includes "https"' do
          before do
            entry.raw_metadata = { subject: 'https://www.example.com/abc123' }
          end

          it 'replaces it with "http"' do
            entry.add_local

            expect(entry.parsed_metadata.dig('subject', 0))
              .to eq('http://www.example.com/abc123')
          end
        end

        context 'when value includes a trailing slash' do
          before do
            entry.raw_metadata = { subject: 'http://www.example.com/abc123/' }
          end

          it 'removes it' do
            entry.add_local

            expect(entry.parsed_metadata.dig('subject', 0))
              .to eq('http://www.example.com/abc123')
          end
        end
      end
    end
  end
end
