# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoneyEntity, type: :entity do
  subject(:serializable_hash) { described_class.new(resource).serializable_hash }

  let(:resource) { Money.new(1000, 'BRL') }

  it 'exposes value' do
    expect(serializable_hash[:value]).to eq resource.to_d.to_s
  end

  it 'exposes currency' do
    expect(serializable_hash[:currency]).to eq resource.currency.iso_code
  end

  it 'exposes formatted' do
    expect(serializable_hash[:formatted]).to eq resource.formatted
  end
end
