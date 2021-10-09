# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::List, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(sort_param: { type: String, default: nil, allow_nil: true }) }
    it { is_expected.to include(user: { type: User, default: nil, allow_nil: true }) }

    it do
      filters_form = inputs.dig(:filters_form, :default).call
      expect(filters_form).to be_a(GameFiltersForm)
    end
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(games: { type: Enumerable }) }
  end

  describe '#call' do
    context 'when filter params is present' do
      let!(:game_on_sale) { create(:game, on_sale: true) }
      let(:filters_form) { GameFiltersForm.build(on_sale: true) }

      before { create(:game, on_sale: false) }

      it 'filters games' do
        result = described_class.result(filters_form: filters_form)

        expect(result.games.to_a).to eq [game_on_sale]
      end
    end

    context 'when sort param is present' do
      let!(:game_a) { create(:game, release_date: Time.zone.today) }
      let!(:game_b) { create(:game, release_date: Time.zone.tomorrow) }
      let!(:game_c) { create(:game, release_date: Time.zone.yesterday) }

      it 'sorts games' do
        result = described_class.result(sort_param: 'release_date_asc')

        expect(result.games.to_a).to eq [game_c, game_a, game_b]
      end
    end

    context 'when user is present' do
      it 'adds wishlisted column' do
        create(:game)
        result = described_class.result(user: User.new(id: Faker::Internet.uuid))

        expect(result.games.first).to respond_to :wishlisted
      end
    end

    context 'when include_hidden filter is filled' do
      let!(:hidden_game) { create(:hidden_game) }
      let!(:not_hidden_game) { create(:game) }

      let(:filters_form) { GameFiltersForm.build(include_hidden: true) }

      it 'returns games including hidden games' do
        result = described_class.result(user: hidden_game.user, filters_form: filters_form)

        expect(result.games).to include(hidden_game.game, not_hidden_game)
      end
    end

    context 'when only_hidden filter is filled' do
      let!(:hidden_game) { create(:hidden_game) }
      let(:filters_form) { GameFiltersForm.build(only_hidden: true) }

      before { create(:game) }

      it 'returns only hidden games' do
        result = described_class.result(user: hidden_game.user, filters_form: filters_form)

        expect(result.games).to eq [hidden_game.game]
      end
    end

    context 'when filter by user wishlist' do
      let!(:wishlist_game) { create(:wishlist_game) }
      let(:filters_form) { GameFiltersForm.build(wishlisted: true) }

      before do
        create(:wishlist_game) # creates game wishlisted by other user
        create(:game) # not wishlisted game
      end

      it 'returns only games present in user wishlist' do
        result = described_class.result(user: wishlist_game.user, filters_form: filters_form)

        expect(result.games.to_a).to eq [wishlist_game.game]
      end
    end
  end
end
