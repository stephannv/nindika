# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NintendoPricesClient, type: :clients do
  describe 'Configurations' do
    it 'has default base_uri' do
      expect(described_class.base_uri).to eq 'https://ec.nintendo.com/api'
    end
  end

  describe '#fetch' do
    subject(:result) { described_class.new.fetch(country: country, lang: lang, nsuids: nsuids) }

    let(:country) { 'XX' }
    let(:lang) { 'YY' }
    let(:nsuids) { %w[123 456 789] }
    let(:querystring) { 'ns_uids=123&ns_uids=456&ns_uids=789' }
    let(:response) { Faker::Types.rb_hash(number: 4).stringify_keys }

    before do
      stub_request(:get, "#{described_class.base_uri}/#{country}/#{lang}/guest_prices?#{querystring}")
        .to_return(body: response.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'requests given nsuids prices from nintendo servers' do
      expect(result).to eq response
    end

    context 'when given nsuids count is greater than 99' do
      let(:nsuids) { (1..100).to_a }

      it 'raises error' do
        expect { result }.to raise_error('NSUIDS are limited to 99 per request')
      end
    end
  end
end
