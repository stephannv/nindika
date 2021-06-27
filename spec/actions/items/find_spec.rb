# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::Find, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(slug: { type: String }) }
    it { is_expected.to include(current_user: { type: User, allow_nil: true, default: nil }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(item: { type: Item }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(slug: slug) }

    context 'when item with given slug exists' do
      let(:item) { create(:item) }
      let(:slug) { item.slug }

      it 'returns found item' do
        expect(result.item).to eq item
      end
    end

    context 'when item with given slug doesn`t exist' do
      let(:slug) { 'not-found-slug' }

      it 'raises not found error' do
        expect { result }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when current user is present' do
      subject(:result) { described_class.result(slug: slug, current_user: user) }

      let(:user) { User.new(id: Faker::Internet.uuid) }
      let(:item) { create(:item) }
      let(:slug) { item.slug }

      it 'left joins with current user wishlist' do
        expect(Items::WithWishlistedColumnQuery).to receive(:call).with(user_id: user.id)

        result
      end

      it 'adds wishlisted column' do
        expect(result.item).to respond_to(:wishlisted)
      end
    end
  end
end
