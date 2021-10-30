# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceEntity, type: :entity do
  subject(:serializable_hash) { described_class.new(resource).serializable_hash }

  let(:resource) { build(:price) }

  it 'exposes base_price' do
    money_hash = MoneyEntity.represent(resource.base_price).serializable_hash

    expect(serializable_hash[:base_price]).to eq money_hash
  end

  context 'when discount_price is present' do
    let(:resource) { build(:price, :with_discount) }

    it 'exposes discount_price' do
      money_hash = MoneyEntity.represent(resource.discount_price).serializable_hash

      expect(serializable_hash[:discount_price]).to eq money_hash
    end
  end

  context 'when discount_price isn`t present' do
    it 'doesn`t expose discount_price' do
      expect(serializable_hash).not_to have_key(:discount_price)
    end
  end

  context 'when discounted_amount is present' do
    let(:resource) { build(:price, :with_discount) }

    it 'exposes discounted_amount' do
      money_hash = MoneyEntity.represent(resource.discounted_amount).serializable_hash

      expect(serializable_hash[:discounted_amount]).to eq money_hash
    end
  end

  context 'when discounted_amount isn`t present' do
    it 'doesn`t expose discounted_amount' do
      expect(serializable_hash).not_to have_key(:discounted_amount)
    end
  end

  context 'when discount_percentage is present' do
    let(:resource) { build(:price, :with_discount) }

    it 'exposes discount_percentage' do
      expect(serializable_hash[:discount_percentage]).to eq resource.discount_percentage
    end
  end

  context 'when discount_percentage isn`t present' do
    it 'doesn`t expose discount_percentage' do
      expect(serializable_hash).not_to have_key(:discount_percentage)
    end
  end

  describe 'state' do
    it 'exposes code' do
      expect(serializable_hash.dig(:state, :code)).to eq resource.state
    end

    it 'exposes text' do
      expect(serializable_hash.dig(:state, :text)).to eq resource.state_humanize
    end
  end

  context 'when discount_started_at is present' do
    let(:resource) { build(:price, :with_discount) }

    it 'exposes discount_started_at' do
      expect(serializable_hash[:discount_started_at]).to eq resource.discount_started_at.iso8601
    end
  end

  context 'when discount_started_at isn`t present' do
    it 'doesn`t expose discount_started_at' do
      expect(serializable_hash).not_to have_key(:discount_started_at)
    end
  end

  context 'when discount_ends_at is present' do
    let(:resource) { build(:price, :with_discount) }

    it 'exposes discount_ends_at' do
      expect(serializable_hash[:discount_ends_at]).to eq resource.discount_ends_at.iso8601
    end
  end

  context 'when discount_ends_at isn`t present' do
    it 'doesn`t expose discount_ends_at' do
      expect(serializable_hash).not_to have_key(:discount_ends_at)
    end
  end
end
