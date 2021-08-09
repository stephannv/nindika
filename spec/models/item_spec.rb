# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Relations' do
    it { is_expected.to have_one(:raw_item).dependent(:destroy) }
    it { is_expected.to have_one(:price).dependent(:destroy) }

    it { is_expected.to have_many(:notifications).dependent(:destroy) }
    it { is_expected.to have_many(:wishlist_items).dependent(:destroy) }
    it { is_expected.to have_many(:hidden_items).dependent(:destroy) }

    it { is_expected.to have_many(:price_history_items).through(:price).source(:history_items) }
  end

  describe 'Configurations' do
    it { is_expected.to monetize(:current_price).allow_nil }
  end

  describe 'Validations' do
    subject(:item) { build(:item) }

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
      let!(:with_nsuid) { create(:item) }

      before { create(:item, nsuid: nil) }

      it 'returns items with nsuid' do
        expect(described_class.with_nsuid.to_a).to eq [with_nsuid]
      end
    end

    describe '.on_sale' do
      let!(:on_sale) { create(:item, on_sale: true) }

      before { create(:item, on_sale: false) }

      it 'returns items on sale' do
        expect(described_class.on_sale.to_a).to eq [on_sale]
      end
    end

    describe '.new_release' do
      let!(:new_release) { create(:item, new_release: true) }

      before { create(:item, new_release: false) }

      it 'returns newly released items' do
        expect(described_class.new_release.to_a).to eq [new_release]
      end
    end

    describe '.coming_soon' do
      let!(:coming_soon) { create(:item, coming_soon: true) }

      before { create(:item, coming_soon: false) }

      it 'returns coming soon items' do
        expect(described_class.coming_soon.to_a).to eq [coming_soon]
      end
    end

    describe '.pre_order' do
      let!(:pre_order) { create(:item, pre_order: true) }

      before { create(:item, pre_order: false) }

      it 'returns pre order items' do
        expect(described_class.pre_order.to_a).to eq [pre_order]
      end
    end
  end

  describe 'Friendly ID' do
    let!(:item_a) { create(:item, title: 'Some title', slug: nil) }
    let!(:item_b) { create(:item, title: 'Other title', slug: nil) }

    before do
      item_a.update(title: 'New title')
    end

    it 'finds record with given slug' do
      expect(described_class.friendly.find('other-title')).to eq item_b
    end

    it 'finds record using slug history' do
      expect(described_class.friendly.find('some-title')).to eq item_a
    end

    it 'generates new slug when title changes' do
      expect(described_class.friendly.find('new-title')).to eq item_a
    end
  end

  describe '#medium_banner_url' do
    let(:item) { described_class.new(banner_url: banner_url) }

    context 'when banner_url includes `upload/ncom`' do
      let(:banner_url) { 'http://example.com/upload/ncom/image.png' }

      it 'inserts resize path into banner_url' do
        expect(item.medium_banner_url).to eq 'http://example.com/upload/c_fill,f_auto,q_auto,w_560/ncom/image.png'
      end
    end

    context 'when banner_url doesn`t include `upload/ncom`' do
      let(:banner_url) { 'http://example.com/ncom/image.png' }

      it 'returns banner url' do
        expect(item.medium_banner_url).to eq 'http://example.com/ncom/image.png'
      end
    end

    context 'when banner_url is nil' do
      let(:banner_url) { nil }

      it 'returns blank string' do
        expect(item.medium_banner_url).to eq ''
      end
    end
  end

  describe '#release_date_text' do
    context 'when release_date_date is a valid date' do
      it 'returns formatted date' do
        item = described_class.new(release_date_display: '2022-04-01')

        expect(item.release_date_text).to eq '01/04/2022'
      end
    end

    context 'when release_date_date is an invalid date' do
      it 'returns release_date_display' do
        item = described_class.new(release_date_display: 'invalid-date')

        expect(item.release_date_text).to eq 'invalid-date'
      end
    end
  end
end
