# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Price, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:item) }
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
end
