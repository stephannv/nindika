# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Item, type: :model do
  describe 'Relations' do
    it { is_expected.to have_one(:raw_item).dependent(:destroy) }
    it { is_expected.to have_one(:price).dependent(:destroy) }

    it { is_expected.to have_many(:notifications).dependent(:destroy) }
    it { is_expected.to have_many(:price_history_items).through(:price).source(:history_items) }
  end

  describe 'Validations' do
    subject(:item) { build(:item) }

    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:title) }

    it { is_expected.to validate_uniqueness_of(:external_id) }

    it { is_expected.to validate_length_of(:external_id).is_at_most(256) }
    it { is_expected.to validate_length_of(:title).is_at_most(1024) }
    it { is_expected.to validate_length_of(:description).is_at_most(8192) }
    it { is_expected.to validate_length_of(:slug).is_at_most(1024) }
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
  end
end
