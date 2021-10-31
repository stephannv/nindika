# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Nindika::V1::GamesAPI, type: :api do
  describe 'GET /v1/games' do
    let(:games) { build_list(:game, 3) }
    let(:total) { 3 }
    let(:params) do
      {
        q: { title: 'Metroid' },
        sort_by: Faker::Lorem.word,
        after: Faker::Internet.uuid
      }
    end

    before do
      allow(Games::List).to receive(:result)
        .with(filter: params[:q], sort_by: params[:sort_by], after: params[:after])
        .and_return(ServiceActor::Result.new(games: games, total: total))
    end

    it 'returns games and total count' do
      get '/v1/games', params: params
      expected_response = { games: GameEntity.represent(games), total: total }.to_json

      expect(response.body).to eq expected_response
    end

    it 'returns status 200 - ok' do
      get '/v1/games', params: params

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET /v1/games/:slug' do
    let(:game) { build(:game, :with_fake_id, slug: 'metroid') }

    before do
      allow(Games::Find).to receive(:result)
        .with(slug: game.slug)
        .and_return(ServiceActor::Result.new(game: game))
    end

    it 'returns game details' do
      get "/v1/games/#{game.slug}"
      expected_response = { game: GameEntity.represent(game, type: :full) }.to_json

      expect(response.body).to eq expected_response
    end

    it 'returns status 200 - ok' do
      get "/v1/games/#{game.slug}"

      expect(response).to have_http_status(:ok)
    end
  end
end
