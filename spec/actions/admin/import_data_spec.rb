# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::ImportData, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    let(:actions) { [RawItems::Import, Prices::Import, Items::UpdateFlags] }

    before { actions.each { |a| allow(a).to receive(:call) } }

    it 'executes data import tasks' do
      expect(actions).to all(receive(:call).ordered)

      result
    end

    it 'creates a task for each action' do
      expect { result }.to change(Admin::Task, :count).by(3)
    end
  end
end
