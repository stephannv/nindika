# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Price, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:item) }

    it { is_expected.to have_many(:history_items).class_name('PriceHistoryItem').dependent(:destroy) }
  end

  describe 'Configurations' do
    it { is_expected.to monetize(:regular_amount) }
    it { is_expected.to monetize(:discount_amount).allow_nil }

    it 'has state enum' do
      expect(described_class.enumerations).to include(state: PriceStates)
    end
  end

  describe 'Validations' do
    subject(:price) { build(:price) }

    it { is_expected.to validate_presence_of(:item_id) }
    it { is_expected.to validate_presence_of(:nsuid) }
    it { is_expected.to validate_presence_of(:state) }

    it { is_expected.to validate_uniqueness_of(:item_id).case_insensitive }
    it { is_expected.to validate_uniqueness_of(:nsuid).case_insensitive }

    it { is_expected.to validate_numericality_of(:regular_amount).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:discount_amount).is_greater_than_or_equal_to(0) }
  end

  describe '#current_amount' do
    context 'when discount amount is present' do
      it 'returns discount amount' do
        price = described_class.new(regular_amount: Money.new(100), discount_amount: Money.new(50))
        expect(price.current_amount).to eq Money.new(50)
      end
    end

    context 'when discount amount is nil' do
      it 'returns regular_amount' do
        price = described_class.new(regular_amount: Money.new(100), discount_amount: nil)
        expect(price.current_amount).to eq Money.new(100)
      end
    end
  end

  describe 'saved_change_to_current_amount?' do
    let(:price) { described_class.new }

    before do
      allow(price).to receive(:saved_change_to_regular_amount_cents?).and_return(false)
      allow(price).to receive(:saved_change_to_discount_amount_cents?).and_return(false)
    end

    context 'when changes for regular_amount_cents was saved' do
      before { allow(price).to receive(:saved_change_to_regular_amount_cents?).and_return(true) }

      it 'returns true' do
        expect(price.saved_change_to_current_amount?).to be(true)
      end
    end

    context 'when changes for discount_amount_cents was saved' do
      before { allow(price).to receive(:saved_change_to_discount_amount_cents?).and_return(true) }

      it 'returns true' do
        expect(price.saved_change_to_current_amount?).to be(true)
      end
    end

    context 'when changes for regular_amount_cents and discount_amount_cents wasn`t saved' do
      it 'returns false' do
        expect(price.saved_change_to_current_amount?).to be(false)
      end
    end
  end

  describe '#discount?' do
    context 'when discount amount is present' do
      it 'returns true' do
        price = described_class.new(discount_amount: 10)

        expect(price.discount?).to eq true
      end
    end

    context 'when discount amount is blank' do
      it 'returns false' do
        price = described_class.new(discount_amount: nil)

        expect(price.discount?).to eq false
      end
    end
  end
end
