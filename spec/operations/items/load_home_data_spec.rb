# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::LoadHomeData, type: :operations do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(trending_games: { type: Enumerable }) }
    it { is_expected.to include(coming_soon_games: { type: Enumerable }) }
    it { is_expected.to include(new_releases_games: { type: Enumerable }) }
    it { is_expected.to include(on_sale_games: { type: Enumerable }) }
    it { is_expected.to include(new_games: { type: Enumerable }) }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    it 'loads trending games' do
      trending_games = create_list(:item, 6, last_week_visits: 100)
      create_list(:item, 2, last_week_visits: 0) # not trending games

      expect(result.trending_games.to_a).to match_array trending_games
    end

    it 'loads coming soon games' do
      coming_soon_games = create_list(:item, 6, coming_soon: true)
      create_list(:item, 2, coming_soon: false) # not coming soon games

      expect(result.coming_soon_games.to_a).to match_array coming_soon_games
    end

    it 'loads new releases games' do
      new_releases_games = create_list(:item, 6, new_release: true)
      create_list(:item, 2, new_release: false) # not new releases games

      expect(result.new_releases_games.to_a).to match_array new_releases_games
    end

    it 'loads on sale games' do
      on_sale_games = create_list(:item, 6, :with_price, on_sale: true)
      create_list(:item, 2, on_sale: false) # not on sale games

      expect(result.on_sale_games.to_a).to match_array on_sale_games
    end

    it 'loads new games' do
      new_games = create_list(:item, 6, created_at: Time.zone.now)
      create_list(:item, 2, created_at: 1.year.ago) # not new games games

      expect(result.new_games.to_a).to match_array new_games
    end
  end
end
