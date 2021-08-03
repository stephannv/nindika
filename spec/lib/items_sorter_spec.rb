# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemsSorter, type: :lib do
  describe '::OPTIONS' do
    subject(:options) { described_class::OPTIONS }

    it 'has all time visits desc sort option' do
      expect(options[:all_time_visits_desc]).to include(text: I18n.t('games.sort_options.all_time_visits_desc'))
    end

    it 'has last week visits desc sort option' do
      expect(options[:last_week_visits_desc]).to include(text: I18n.t('games.sort_options.last_week_visits_desc'))
    end

    it 'has title asc sort option' do
      expect(options[:title_asc]).to include(text: I18n.t('games.sort_options.title_asc'))
    end

    it 'has release date asc sort option' do
      expect(options[:release_date_asc]).to include(text: I18n.t('games.sort_options.release_date_asc'))
    end

    it 'has release date desc sort option' do
      expect(options[:release_date_desc]).to include(text: I18n.t('games.sort_options.release_date_desc'))
    end

    it 'has price asc sort option' do
      expect(options[:price_asc]).to include(text: I18n.t('games.sort_options.price_asc'))
    end

    it 'has price desc sort option' do
      expect(options[:price_desc]).to include(text: I18n.t('games.sort_options.price_desc'))
    end

    it 'has discounted amount desc sort option' do
      expect(options[:discounted_amount_desc]).to include(text: I18n.t('games.sort_options.discounted_amount_desc'))
    end

    it 'has discount percentage desc sort option' do
      expect(options[:discount_percentage_desc]).to include(text: I18n.t('games.sort_options.discount_percentage_desc'))
    end

    it 'has discount start date desc sort option' do
      expect(options[:discount_start_date_desc]).to include(text: I18n.t('games.sort_options.discount_start_date_desc'))
    end

    it 'has discount end date asc sort option' do
      expect(options[:discount_end_date_asc]).to include(text: I18n.t('games.sort_options.discount_end_date_asc'))
    end
  end

  describe '#apply' do
    subject(:result) { described_class.apply(Item, sort_option) }

    context 'when sort options is title_asc' do
      let(:sort_option) { 'title_asc' }
      let!(:item_c) { create(:item, title: 'c') }
      let!(:item_a) { create(:item, title: 'a') }
      let!(:item_b) { create(:item, title: 'b') }

      it 'sorts items by title ascending' do
        expect(result.to_a).to eq [item_a, item_b, item_c]
      end
    end

    context 'when sort options is release_date_asc' do
      let(:sort_option) { 'release_date_asc' }
      let!(:item_c) { create(:item, release_date: 1.week.from_now) }
      let!(:item_a) { create(:item, release_date: 1.week.ago) }
      let!(:item_b) { create(:item, release_date: Time.zone.today) }

      it 'sorts items by release date ascending' do
        expect(result.to_a).to eq [item_a, item_b, item_c]
      end
    end

    context 'when sort options is release_date_desc' do
      let(:sort_option) { 'release_date_desc' }
      let!(:item_c) { create(:item, release_date: 1.week.from_now) }
      let!(:item_a) { create(:item, release_date: 1.week.ago) }
      let!(:item_b) { create(:item, release_date: Time.zone.today) }

      it 'sorts items by release date descending' do
        expect(result.to_a).to eq [item_c, item_b, item_a]
      end
    end

    context 'when sort options is price_asc' do
      let(:sort_option) { 'price_asc' }
      let!(:item_c) { create(:price, base_price: 100).item }
      let!(:item_a) { create(:price, discount_price: 40).item }
      let!(:item_b) { create(:price, base_price: 60).item }

      it 'sorts items by current price ascending' do
        expect(result.to_a).to eq [item_a, item_b, item_c]
      end
    end

    context 'when sort options is price_desc' do
      let(:sort_option) { 'price_desc' }
      let!(:item_c) { create(:price, base_price: 100).item }
      let!(:item_a) { create(:price, discount_price: 40).item }
      let!(:item_b) { create(:price, base_price: 60).item }

      it 'sorts items by current price descending' do
        expect(result.to_a).to eq [item_c, item_b, item_a]
      end
    end

    context 'when sort options is discounted_amount_desc' do
      let(:sort_option) { 'discounted_amount_desc' }
      let!(:item_a) { create(:price, discounted_amount: 40).item }
      let!(:item_c) { create(:price, discounted_amount: 100).item }
      let!(:item_b) { create(:price, discounted_amount: 60).item }

      it 'sorts items by discount percentage descending' do
        expect(result.to_a).to eq [item_c, item_b, item_a]
      end
    end

    context 'when sort options is discount_percentage_desc' do
      let(:sort_option) { 'discount_percentage_desc' }
      let!(:item_c) { create(:price, discount_percentage: 100).item }
      let!(:item_a) { create(:price, discount_percentage: 40).item }
      let!(:item_b) { create(:price, discount_percentage: 60).item }

      it 'sorts items by discount percentage descending' do
        expect(result.to_a).to eq [item_c, item_b, item_a]
      end
    end

    context 'when sort options is discount_start_date_desc' do
      let(:sort_option) { 'discount_start_date_desc' }
      let!(:item_c) { create(:price, discount_started_at: 1.week.from_now).item }
      let!(:item_a) { create(:price, discount_started_at: 1.week.ago).item }
      let!(:item_b) { create(:price, discount_started_at: Time.zone.today).item }

      it 'sorts items by price discount start date descending' do
        expect(result.to_a).to eq [item_c, item_b, item_a]
      end
    end

    context 'when sort options is discount_end_date_asc' do
      let(:sort_option) { 'discount_end_date_asc' }
      let!(:item_c) { create(:price, discount_ends_at: 1.week.from_now).item }
      let!(:item_a) { create(:price, discount_ends_at: 1.week.ago).item }
      let!(:item_b) { create(:price, discount_ends_at: Time.zone.today).item }

      it 'sorts items by price discount end date ascending' do
        expect(result.to_a).to eq [item_a, item_b, item_c]
      end
    end
  end
end
