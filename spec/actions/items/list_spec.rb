# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::List, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it do
      expect(inputs).to include(
        filter_params: { type: [Hash, ActionController::Parameters], default: {}, allow_nil: true }
      )
    end

    it { is_expected.to include(sort_param: { type: String, default: nil, allow_nil: true }) }
    it { is_expected.to include(current_user: { type: User, default: nil, allow_nil: true }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(items: { type: Enumerable }) }
  end

  describe '#call' do
    subject(:result) do
      described_class.result(filter_params: filter_params, sort_param: sort_param, current_user: user)
    end

    let(:ordered_items) { create_list(:item, 3, :with_price) }
    let(:filter_params) { Faker::Types.rb_hash(number: 4) }
    let(:sort_param) { Faker::Lorem.word }
    let(:user) { nil }

    before do
      filtered_items = create_list(:item, 2, :with_price)

      allow(ItemsFilter).to receive(:apply)
        .with(kind_of(ActiveRecord::Relation), filter_params)
        .and_return(filtered_items)

      allow(ItemsSorter).to receive(:apply)
        .with(filtered_items, sort_param)
        .and_return(ordered_items)
    end

    it 'returns items with applied filters' do
      expect(result.items.to_a).to include(*ordered_items)
    end

    context 'when current user is present' do
      let(:user) { User.new(id: Faker::Internet.uuid) }

      before do
        allow(ItemsSorter).to receive(:apply).and_return(Item)

        allow(Item).to receive(:with_wishlisted_column)
          .with(user_id: user.id)
          .and_return(Item)
      end

      it 'adds wishlisted column' do
        expect(Item).to receive(:with_wishlisted_column).with(user_id: user.id)

        result
      end

      it 'removes hidden items' do
        expect(Item).to receive(:without_hidden).with(user_id: user.id).and_call_original

        result
      end
    end
  end
end
