# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'Relations' do
    it { is_expected.to have_one(:raw_item).dependent(:destroy) }
    it { is_expected.to have_one(:price).dependent(:destroy) }

    it { is_expected.to have_many(:events).class_name('GameEvent').dependent(:destroy) }
    it { is_expected.to have_many(:wishlist_games).dependent(:destroy) }
    it { is_expected.to have_many(:hidden_games).dependent(:destroy) }

    it { is_expected.to have_many(:price_history_items).through(:price).source(:history_items) }
  end

  describe 'Configurations' do
    it { is_expected.to monetize(:current_price).allow_nil }
  end

  describe 'Validations' do
    subject(:game) { build(:game) }

    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_uniqueness_of(:external_id) }

    it { is_expected.to validate_length_of(:external_id).is_at_most(256) }
    it { is_expected.to validate_length_of(:title).is_at_most(1024) }
    it { is_expected.to validate_length_of(:description).is_at_most(8192) }
    it { is_expected.to validate_length_of(:website_url).is_at_most(1024) }
    it { is_expected.to validate_length_of(:nsuid).is_at_most(32) }
    it { is_expected.to validate_length_of(:boxart_url).is_at_most(1024) }
    it { is_expected.to validate_length_of(:banner_url).is_at_most(1024) }
    it { is_expected.to validate_length_of(:release_date_display).is_at_most(64) }
    it { is_expected.to validate_length_of(:content_rating).is_at_most(64) }
  end

  describe 'Scopes' do
    describe '.with_nsuid' do
      let!(:with_nsuid) { create(:game) }

      before { create(:game, nsuid: nil) }

      it 'returns games with nsuid' do
        expect(described_class.with_nsuid.to_a).to eq [with_nsuid]
      end
    end

    describe '.on_sale' do
      let!(:on_sale) { create(:game, on_sale: true) }

      before { create(:game, on_sale: false) }

      it 'returns games on sale' do
        expect(described_class.on_sale.to_a).to eq [on_sale]
      end
    end

    describe '.new_release' do
      let!(:new_release) { create(:game, new_release: true) }

      before { create(:game, new_release: false) }

      it 'returns newly released games' do
        expect(described_class.new_release.to_a).to eq [new_release]
      end
    end

    describe '.coming_soon' do
      let!(:coming_soon) { create(:game, coming_soon: true) }

      before { create(:game, coming_soon: false) }

      it 'returns coming soon games' do
        expect(described_class.coming_soon.to_a).to eq [coming_soon]
      end
    end

    describe '.pre_order' do
      let!(:pre_order) { create(:game, pre_order: true) }

      before { create(:game, pre_order: false) }

      it 'returns pre order games' do
        expect(described_class.pre_order.to_a).to eq [pre_order]
      end
    end

    describe '.pending_scrap' do
      let!(:not_scraped) { create(:game, last_scraped_at: nil) }
      let!(:scraped_long_ago) { create(:game, last_scraped_at: 25.hours.ago) }

      before { create(:game, last_scraped_at: 23.hours.ago) } # scraped recently

      it 'returns not scraped games or scraped more than 24 hours ago' do
        expect(described_class.pending_scrap.to_a).to match_array [not_scraped, scraped_long_ago]
      end
    end
  end

  describe 'Friendly ID' do
    let!(:game_a) { create(:game, title: 'Some title', slug: nil) }
    let!(:game_b) { create(:game, title: 'Other title', slug: nil) }

    before do
      game_a.update(title: 'New title')
    end

    it 'finds record with given slug' do
      expect(described_class.friendly.find('other-title')).to eq game_b
    end

    it 'finds record using slug history' do
      expect(described_class.friendly.find('some-title')).to eq game_a
    end

    it 'generates new slug when title changes' do
      expect(described_class.friendly.find('new-title')).to eq game_a
    end
  end

  describe '#medium_banner_url' do
    let(:game) { described_class.new(banner_url: banner_url) }

    context 'when banner_url includes `upload/ncom`' do
      let(:banner_url) { 'http://example.com/upload/ncom/image.png' }

      it 'inserts resize path into banner_url' do
        expect(game.medium_banner_url).to eq 'http://example.com/upload/c_fill,f_auto,q_auto,w_560/ncom/image.png'
      end
    end

    context 'when banner_url doesn`t include `upload/ncom`' do
      let(:banner_url) { 'http://example.com/ncom/image.png' }

      it 'returns banner url' do
        expect(game.medium_banner_url).to eq 'http://example.com/ncom/image.png'
      end
    end

    context 'when banner_url is nil' do
      let(:banner_url) { nil }

      it 'returns blank string' do
        expect(game.medium_banner_url).to eq ''
      end
    end
  end

  describe '#release_date_text' do
    context 'when release_date_date is a valid date' do
      it 'returns formatted date' do
        game = described_class.new(release_date_display: '2022-04-01')

        expect(game.release_date_text).to eq '01/04/2022'
      end
    end

    context 'when release_date_date is an invalid date' do
      it 'returns release_date_display' do
        game = described_class.new(release_date_display: 'invalid-date')

        expect(game.release_date_text).to eq 'invalid-date'
      end
    end
  end
end
