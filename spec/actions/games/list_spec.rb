# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::List, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(sort_by: { type: String, default: nil, allow_nil: true }) }
    it { is_expected.to include(after: { type: String, default: nil, allow_nil: true }) }
    it { is_expected.to include(per_page: { type: Integer, default: 20 }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(games: { type: Enumerable }) }
    it { is_expected.to include(total: { type: Integer }) }
  end

  describe '#call' do
    context 'when filter params is present' do
      let!(:game_on_sale) { create(:game, on_sale: true) }
      let(:filters_form) { GameFiltersForm.build(on_sale: true) }

      before { create(:game, on_sale: false) }

      xit 'filters games' do
        result = described_class.result(filters_form: filters_form)

        expect(result.games.to_a).to eq [game_on_sale]
      end
    end

    context 'when sort_by is present' do
      let!(:game_a) { create(:game, release_date: Time.zone.today) }
      let!(:game_b) { create(:game, release_date: Time.zone.tomorrow) }
      let!(:game_c) { create(:game, release_date: Time.zone.yesterday) }

      it 'sorts games' do
        result = described_class.result(sort_by: 'release_date:asc')

        expect(result.games.to_a).to eq [game_c, game_a, game_b]
      end
    end

    context 'when after is present' do
      let!(:game_a) { create(:game, release_date: Time.zone.today) }
      let!(:game_b) { create(:game, release_date: Time.zone.tomorrow) }

      before { create(:game, release_date: Time.zone.yesterday) }

      it 'returns games after given game id' do
        result = described_class.result(sort_by: 'release_date:asc', after: game_a.id)

        expect(result.games.to_a).to eq [game_b]
      end
    end

    it 'returns total games count' do
      create_list(:game, 5)
      result = described_class.result

      expect(result.total).to eq 5
    end
  end
end
