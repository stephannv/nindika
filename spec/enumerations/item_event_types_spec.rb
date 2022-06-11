# frozen_string_literal: true

require "rails_helper"

RSpec.describe ItemEventTypes, type: :enumeration do
  subject { described_class.list }

  it { is_expected.to include "game_added" }
  it { is_expected.to include "price_added" }
  it { is_expected.to include "discount" }
  it { is_expected.to include "permanent_price_change" }
  it { is_expected.to include "price_state_change" }

  describe ItemEventTypes::GameAdded do
    describe "#emoji" do
      subject { described_class.new.emoji }

      it { is_expected.to eq "✨" }
    end
  end

  describe ItemEventTypes::PriceAdded do
    describe "#emoji" do
      subject { described_class.new.emoji }

      it { is_expected.to eq "💰" }
    end
  end

  describe ItemEventTypes::Discount do
    describe "#emoji" do
      subject { described_class.new.emoji }

      it { is_expected.to eq "🤑" }
    end
  end

  describe ItemEventTypes::PermanentPriceChange do
    describe "#emoji" do
      subject { described_class.new.emoji }

      it { is_expected.to eq "🔧" }
    end
  end

  describe ItemEventTypes::PriceStateChange do
    describe "#emoji" do
      subject { described_class.new.emoji }

      it { is_expected.to eq "❌" }
    end
  end
end
