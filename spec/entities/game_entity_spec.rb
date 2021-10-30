# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameEntity, type: :entity do
  subject(:serializable_hash) { described_class.new(resource).serializable_hash }

  let(:resource) { build(:game, :with_price, :with_fake_id) }

  it 'exposes id' do
    expect(serializable_hash[:id]).to eq resource.id
  end

  it 'exposes title' do
    expect(serializable_hash[:title]).to eq resource.title
  end

  it 'exposes slug' do
    expect(serializable_hash[:slug]).to eq resource.slug
  end

  it 'exposes banner_url' do
    expect(serializable_hash[:banner_url]).to eq resource.banner_url
  end

  it 'exposes price' do
    price_hash = PriceEntity.represent(resource.price).serializable_hash

    expect(serializable_hash[:price]).to eq price_hash
  end
end
