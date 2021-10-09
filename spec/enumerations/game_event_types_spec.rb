# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameEventTypes, type: :enumeration do
  subject { described_class.list }

  it { is_expected.to include 'game_added' }
  it { is_expected.to include 'price_added' }
  it { is_expected.to include 'discount' }
  it { is_expected.to include 'permanent_price_change' }
  it { is_expected.to include 'price_state_change' }

  describe GameEventTypes::GameAdded do
    describe '#emoji' do
      subject { described_class.new.emoji }

      it { is_expected.to eq '✨' }
    end
  end

  describe GameEventTypes::PriceAdded do
    describe '#emoji' do
      subject { described_class.new.emoji }

      it { is_expected.to eq '💰' }
    end
  end

  describe GameEventTypes::Discount do
    describe '#emoji' do
      subject { described_class.new.emoji }

      it { is_expected.to eq '🤑' }
    end
  end

  describe GameEventTypes::PermanentPriceChange do
    describe '#emoji' do
      subject { described_class.new.emoji }

      it { is_expected.to eq '🔧' }
    end
  end

  describe GameEventTypes::PriceStateChange do
    describe '#emoji' do
      subject { described_class.new.emoji }

      it { is_expected.to eq '❌' }
    end
  end
end
