# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::Filter, type: :lib do
  describe '#apply' do
    subject(:result) { described_class.apply(relation: Game, filter_form_object: filter_form_object) }

    context 'when title is present' do
      let(:filter_form_object) { Games::FilterFormObject.build(title: 'leslie') }
      let!(:game) { create(:game, title: 'As confusões de Leslie') }

      before { create_list(:game, 3, :with_price) }

      it 'returns games filtering by title' do
        expect(result.to_a).to eq [game]
      end
    end

    context 'when release_date range is present' do
      let(:filter_form_object) do
        Games::FilterFormObject.build(release_date_gteq: 2.months.ago, release_date_lteq: Time.zone.tomorrow)
      end
      let!(:game_a) { create(:game, release_date: 1.month.ago) }
      let!(:game_b) { create(:game, release_date: Time.zone.today) }

      before { create(:game, release_date: 1.month.from_now) }

      it 'returns games filtering by release date range' do
        expect(result.to_a).to eq [game_a, game_b]
      end
    end

    context 'when price range is present' do
      let(:filter_form_object) { Games::FilterFormObject.build(price_gteq: 9, price_lteq: 22) }
      let!(:game_a) { create(:game, current_price: 10) }
      let!(:game_b) { create(:game, current_price: 20) }

      before { create(:game, current_price: 30) }

      it 'returns games filtering by price range' do
        expect(result.to_a).to eq [game_a, game_b]
      end
    end

    context 'when genre is present' do
      let(:filter_form_object) { Games::FilterFormObject.build(genre: 'action') }
      let!(:game_a) { create(:game, genres: %w[action racing]) }
      let!(:game_c) { create(:game, genres: %w[action]) }

      before { create(:game, genres: %w[role_playing]) }

      it 'returns games filtering by genre' do
        expect(result.to_a).to eq [game_a, game_c]
      end
    end

    context 'when language is present' do
      let(:filter_form_object) { Games::FilterFormObject.build(language: 'PT') }

      let!(:game_a) { create(:game, languages: %w[PT]) }
      let!(:game_c) { create(:game, languages: %w[PT EN JP]) }

      before { create(:game, languages: %w[EN JP ES]) }

      it 'returns games filtering by language' do
        expect(result.to_a).to eq [game_a, game_c]
      end
    end

    context 'when on_sale param is true' do
      let(:filter_form_object) { Games::FilterFormObject.build(on_sale: true) }
      let!(:game) { create(:game, on_sale: true) }

      before { create_list(:game, 3, on_sale: false) }

      it 'returns games on sale' do
        expect(result.to_a).to eq [game]
      end
    end

    context 'when new_release param is true' do
      let(:filter_form_object) { Games::FilterFormObject.build(new_release: true) }
      let!(:game) { create(:game, new_release: true) }

      before { create_list(:game, 3, new_release: false) }

      it 'returns new releases games' do
        expect(result.to_a).to eq [game]
      end
    end

    context 'when coming_soon param is true' do
      let(:filter_form_object) { Games::FilterFormObject.build(coming_soon: true) }
      let!(:game) { create(:game, coming_soon: true) }

      before { create_list(:game, 3, coming_soon: false) }

      it 'returns coming soon games' do
        expect(result.to_a).to eq [game]
      end
    end

    context 'when pre_order param is true' do
      let(:filter_form_object) { Games::FilterFormObject.build(pre_order: true) }
      let!(:game) { create(:game, pre_order: true) }

      before { create_list(:game, 3, pre_order: false) }

      it 'returns pre order games' do
        expect(result.to_a).to eq [game]
      end
    end
  end
end
