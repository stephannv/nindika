# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notifications::List, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(notifications: { type: Enumerable }) }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    let!(:notifications) { create_list(:notification, 5) }

    it 'returns all notifications' do
      expect(result.notifications.to_a).to include(*notifications)
    end
  end
end
