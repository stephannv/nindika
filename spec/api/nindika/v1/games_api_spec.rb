# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nindika::V1::GamesAPI, type: :api do
  describe 'GET /v1/games' do
    let(:games) { build_list(:game, 3) }
    let(:total) { 3 }
    let(:params) do
      {
        sort_by: Faker::Lorem.word,
        after: Faker::Internet.uuid
      }
    end

    before do
      allow(Games::List).to receive(:result)
        .with(sort_by: params[:sort_by], after: params[:after])
        .and_return(ServiceActor::Result.new(games: games, total: total))
    end

    it 'returns games and total count' do
      get '/v1/games', params: params
      expected_response = { games: GameEntity.represent(games), total: total }.to_json

      expect(response.body).to eq expected_response
    end
  end
end
