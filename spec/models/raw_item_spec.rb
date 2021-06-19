# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RawItem, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:item).optional }
  end

  describe 'Validations' do
    subject(:raw_item) { build(:raw_item) }

    it { is_expected.to validate_presence_of(:external_id) }
    it { is_expected.to validate_presence_of(:checksum) }

    it { is_expected.to validate_uniqueness_of(:external_id) }

    it do
      create(:raw_item, :with_item)
      expect(raw_item).to validate_uniqueness_of(:item_id).allow_nil.case_insensitive
    end

    it { is_expected.to validate_length_of(:external_id).is_at_most(256) }
    it { is_expected.to validate_length_of(:checksum).is_at_most(512) }
  end

  describe 'Scopes' do
    describe '.pending' do
      it 'returns not imported raw items' do
        not_imported_raw_item = create(:raw_item, imported: false)
        create(:raw_item, imported: true)
        expect(described_class.pending).to match_array [not_imported_raw_item]
      end
    end
  end
end
