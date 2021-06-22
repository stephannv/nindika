# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::Task, type: :model do
  describe '.start' do
    it 'creates a new task' do
      expect { described_class.start('hello') }.to change(described_class, :count).by(1)
    end

    it 'executes given block' do
      object = nil
      described_class.start 'hello' do
        object = create(:item)
      end

      expect(object).to be_persisted
    end

    context 'when given block is executed succesfully' do
      it 'updates task status to done' do
        described_class.start('hello') { puts 'hello' }

        expect(described_class.last.status).to eq 'done'
      end
    end

    context 'when given block raises error' do
      let(:error) { StandardError.new('Some error') }

      before { described_class.start('hello') { raise error } }

      it 'updates task status to failed' do
        expect(described_class.last.status).to eq 'failed'
      end

      it 'updates task message to error message' do
        expect(described_class.last.message).to eq 'StandardError - Some error'
      end
    end
  end
end
