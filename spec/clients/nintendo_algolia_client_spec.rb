# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NintendoAlgoliaClient, type: :client do
  describe '#fetch' do
    subject(:client) { described_class.new }

    let(:index) { client.index_desc }
    let(:hits) { [double] }
    let(:response) { { hits: hits } }
    let(:query) { Faker::Lorem.word }

    before do
      allow(index).to receive(:search)
        .with(query, queryType: 'prefixAll', hitsPerPage: 500, filters: 'platform:"Nintendo Switch"')
        .and_return(response)
    end

    it 'returns hits from search result' do
      expect(client.fetch(index: index, query: query)).to eq hits
    end
  end

  describe '#index_asc' do
    subject(:client) { described_class.new(client: algolia_client) }

    let(:algolia_client) { double }
    let(:index) { double }

    context 'when @index_asc is nil' do
      before do
        client.instance_variable_set(:@index_asc, nil)
        allow(algolia_client).to receive(:init_index).with('ncom_game_pt_br_title_asc').and_return(index)
      end

      it 'returns a algolia index with title asc' do
        expect(client.index_asc).to eq index
      end
    end

    context 'when @index_asc isn`t nil' do
      before do
        client.instance_variable_set(:@index_asc, index)
      end

      it 'doesn`t call :init_index' do
        expect(algolia_client).not_to receive(:init_index)
      end

      it 'returns @index_asc' do
        expect(client.index_asc).to eq index
      end
    end
  end

  describe '#index_desc' do
    subject(:client) { described_class.new(client: algolia_client) }

    let(:algolia_client) { double }
    let(:index) { double }

    context 'when @index_desc is nil' do
      before do
        client.instance_variable_set(:@index_desc, nil)
        allow(algolia_client).to receive(:init_index).with('ncom_game_pt_br_title_des').and_return(index)
      end

      it 'returns a algolia index with title desc' do
        expect(client.index_desc).to eq index
      end
    end

    context 'when @index_desc isn`t nil' do
      before do
        client.instance_variable_set(:@index_desc, index)
      end

      it 'doesn`t call :init_index' do
        expect(algolia_client).not_to receive(:init_index)

        client.index_desc
      end

      it 'returns @index_desc' do
        expect(client.index_desc).to eq index
      end
    end
  end
end
