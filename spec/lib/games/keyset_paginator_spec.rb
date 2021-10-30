# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::KeysetPaginator, type: :lib do
  describe '.sort_and_paginate' do
    subject(:result) { described_class.sort_and_paginate(**args.merge(relation: Game.left_joins(:price))) }

    context 'when sort_by is title:asc' do
      let(:args) { { sort_by: 'title:asc' } }
      let!(:game_c) { create(:game, title: 'c') }
      let!(:game_a) { create(:game, title: 'a') }
      let!(:game_b) { create(:game, title: 'b') }

      it 'sorts games by title ascending' do
        expect(result.to_a).to eq [game_a, game_b, game_c]
      end
    end

    context 'when sort_by is release_date:desc' do
      let(:args) { { sort_by: 'release_date:desc' } }

      let!(:game_c) { create(:game, release_date: 1.week.from_now) }
      let!(:game_a) { create(:game, release_date: 1.week.ago) }
      let!(:game_b) { create(:game, release_date: Time.zone.today) }

      it 'sorts games by release date descending' do
        expect(result.to_a).to eq [game_c, game_b, game_a]
      end
    end

    context 'when sort_by is release_date:asc' do
      let(:args) { { sort_by: 'release_date:asc' } }

      let!(:game_c) { create(:game, release_date: 1.week.from_now) }
      let!(:game_a) { create(:game, release_date: 1.week.ago) }
      let!(:game_b) { create(:game, release_date: Time.zone.today) }

      it 'sorts games by release date ascending' do
        expect(result.to_a).to eq [game_a, game_b, game_c]
      end
    end

    context 'when sort_by is price:asc' do
      let(:args) { { sort_by: 'price:asc' } }

      let!(:game_c) { create(:game, current_price: 100) }
      let!(:game_a) { create(:game, current_price: 40) }
      let!(:game_b) { create(:game, current_price: 60) }

      it 'sorts games by current price ascending' do
        expect(result.to_a).to eq [game_a, game_b, game_c]
      end
    end

    context 'when sort_by is price:desc' do
      let(:args) { { sort_by: 'price:desc' } }

      let!(:game_c) { create(:game, current_price: 100) }
      let!(:game_a) { create(:game, current_price: 40) }
      let!(:game_b) { create(:game, current_price: 60) }

      it 'sorts games by current price descending' do
        expect(result.to_a).to eq [game_c, game_b, game_a]
      end
    end

    context 'when sort_by is discounted_amount:desc' do
      let(:args) { { sort_by: 'discounted_amount:desc' } }

      let!(:game_a) { create(:price, discounted_amount: 40).game }
      let!(:game_c) { create(:price, discounted_amount: 100).game }
      let!(:game_b) { create(:price, discounted_amount: 60).game }

      it 'sorts games by discount percentage descending' do
        expect(result.to_a).to eq [game_c, game_b, game_a]
      end
    end

    context 'when sort_by is discount_percentage:desc' do
      let(:args) { { sort_by: 'discount_percentage:desc' } }

      let!(:game_c) { create(:price, discount_percentage: 100).game }
      let!(:game_a) { create(:price, discount_percentage: 40).game }
      let!(:game_b) { create(:price, discount_percentage: 60).game }

      it 'sorts games by discount percentage descending' do
        expect(result.to_a).to eq [game_c, game_b, game_a]
      end
    end

    context 'when sort_by is discount_start_date:desc' do
      let(:args) { { sort_by: 'discount_start_date:desc' } }

      let!(:game_c) { create(:price, discount_started_at: 1.week.from_now).game }
      let!(:game_a) { create(:price, discount_started_at: 1.week.ago).game }
      let!(:game_b) { create(:price, discount_started_at: Time.zone.today).game }

      it 'sorts games by price discount start date descending' do
        expect(result.to_a).to eq [game_c, game_b, game_a]
      end
    end

    context 'when sort_by is discount_end_date:asc' do
      let(:args) { { sort_by: 'discount_end_date:asc' } }

      let!(:game_c) { create(:price, discount_ends_at: 1.week.from_now).game }
      let!(:game_a) { create(:price, discount_ends_at: 1.week.ago).game }
      let!(:game_b) { create(:price, discount_ends_at: Time.zone.today).game }

      it 'sorts games by price discount end date ascending' do
        expect(result.to_a).to eq [game_a, game_b, game_c]
      end
    end

    context 'with per_page param' do
      let(:args) { { per_page: 4 } }

      before { create_list(:game, 6) }

      it 'limits page result size' do
        expect(result.size).to eq 4
      end
    end

    context 'with after param' do
      let!(:page_3) { create_list(:game, 5, :with_price, current_price: Faker::Number.number(digits: 5)) }
      let!(:page_1) { create_list(:game, 5, :with_price, current_price: Faker::Number.number(digits: 3)) }
      let!(:page_2) { create_list(:game, 5, :with_price, current_price: Faker::Number.number(digits: 4)) }

      let(:args) { { relation: Game.left_joins(:price), sort_by: 'price:asc', per_page: 5 } }

      it 'return games after given id' do
        after = nil

        [page_1, page_2, page_3].each do |page|
          result = described_class.sort_and_paginate(**args.merge(after: after))

          expect(result.to_a).to contain_exactly(*page)
          after = page.pluck(:id).max
        end
      end
    end
  end
end
