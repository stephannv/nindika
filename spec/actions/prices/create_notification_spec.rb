# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Prices::CreateNotification, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(price: { type: Price }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result(price: price) }

    let(:price) { create(:price) }

    context 'when price didn`t change current amount' do
      before { allow(price).to receive(:saved_change_to_current_price?).and_return(false) }

      it { is_expected.to be_failure }

      it 'doesn`t create a new notification' do
        expect { result }.not_to change(Notification, :count)
      end
    end

    context 'when price changed current amount' do
      let(:notification_data) { attributes_for(:notification) }

      before do
        allow(price).to receive(:saved_change_to_current_price?).and_return(true)
        allow(PriceNotificationDataBuilder).to receive(:build).with(price: price).and_return(notification_data)
      end

      it 'creates a new notification' do
        expect { result }.to change(Notification, :count).by(1)
      end

      it 'creates new notification using price notification data builder' do
        result

        expect(Notification.last.attributes).to include(notification_data.deep_stringify_keys)
      end
    end

    context 'when notification builder returns nil' do
      before do
        allow(price).to receive(:saved_change_to_current_price?).and_return(true)
        allow(PriceNotificationDataBuilder).to receive(:build).with(price: price).and_return(nil)
      end

      it 'doesn`t creates a new notification' do
        expect { result }.not_to change(Notification, :count)
      end
    end
  end
end
