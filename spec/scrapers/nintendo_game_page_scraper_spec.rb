# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NintendoGamePageScraper, type: :scraper do
  describe '#scrap' do
    subject(:scraped_data) { described_class.scrap(url) }

    let(:url) { Faker::Internet.url }

    context 'when page exists' do
      before do
        stub_request(:get, url).to_return(body: file_fixture('eastward-game-page.html'), status: 200)
      end

      it 'scraps languages' do
        expect(scraped_data[:languages]).to eq %w[Japonês Francês Chinês Inglês]
      end

      it 'scraps game size' do
        expect(scraped_data[:size]).to eq '1.3 GB'
      end
    end

    context 'when page doesn`t exist' do
      before do
        stub_request(:get, url).to_return(body: file_fixture('eastward-game-page.html'), status: 404)
      end

      it 'returns an empty hash' do
        expect(scraped_data).to eq({})
      end
    end
  end
end
