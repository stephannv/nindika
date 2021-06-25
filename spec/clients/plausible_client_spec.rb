# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlausibleClient, type: :clients do
  describe 'Configurations' do
    it 'has default base_uri' do
      expect(described_class.base_uri).to eq 'https://analytics.nindika.com/api/v1'
    end

    it 'has default params' do
      expect(described_class.default_params).to eq(site_id: 'nindika.com')
    end

    it 'has default headers' do
      expect(described_class.headers).to eq(
        'Authorization' => "Bearer #{Rails.application.credentials.plausible_api_key}"
      )
    end
  end

  describe '#stats_grouped_by_page' do
    subject(:client) { described_class.new }

    let(:period) { Date.parse('2020-01-01')..Date.parse('2020-04-25') }
    let(:page) { 4 }
    let(:limit) { 200 }
    let(:results) { [Faker::Types.rb_hash(number: 4).stringify_keys, Faker::Types.rb_hash(number: 4).stringify_keys] }

    before do
      query = described_class.default_params.merge(
        property: 'event:page', period: 'custom', date: '2020-01-01,2020-04-25', page: page, limit: limit
      )
      stub_request(:get, "#{described_class.base_uri}/stats/breakdown")
        .with(query: query)
        .to_return(body: { 'results' => results }.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'requests /stats/breakdown grouping by page and filtering by period' do
      expect(client.stats_grouped_by_page(period: period, page: page, limit: limit)).to eq results
    end
  end
end
