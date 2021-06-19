# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceHistoryItem, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:price) }
  end

  describe 'Configurations' do
    it { is_expected.to monetize(:amount) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:price_id) }
    it { is_expected.to validate_presence_of(:reference_date) }

    it 'validates uniqueness of reference date scoped to price_id' do
      price_change_record = create(:price_history_item)
      expect(price_change_record).to validate_uniqueness_of(:reference_date).scoped_to(:price_id)
    end

    it { is_expected.to validate_numericality_of(:amount).is_greater_than_or_equal_to(0) }
  end
end
