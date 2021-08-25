# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::WithHiddenColumnQuery, type: :query do
  describe '#call' do
    let(:user) { create(:user) }
    let!(:hidden_item) { create(:hidden_item, user: user).item }
    let!(:other_items) { create_list(:item, 5) }
    let!(:hidden_item_by_other_user) { create(:hidden_item).item }

    context 'when include hidden is true' do
      subject(:result) { described_class.call(user_id: user.id, include_hidden: true) }

      it 'returns all items including hidden items' do
        expect(result.to_a).to match_array [hidden_item, other_items, hidden_item_by_other_user].flatten
      end
    end

    context 'when only hidden is true' do
      subject(:result) { described_class.call(user_id: user.id, only_hidden: true) }

      it 'returns only hidden items' do
        expect(result.to_a).to match_array [hidden_item]
      end
    end

    context 'when only hidden and include hidden are false' do
      subject(:result) { described_class.call(user_id: user.id, include_hidden: false, only_hidden: false) }

      it 'returns all items excluding hidden items' do
        expect(result.to_a).to match_array [other_items, hidden_item_by_other_user].flatten
      end
    end

    context 'when item is hidden' do
      subject(:result) { described_class.call(user_id: user.id, include_hidden: true) }

      it 'sets hidden column as true' do
        expect(result.find_by(id: hidden_item.id).hidden).to be true
      end
    end

    context 'when item isn`t hidden' do
      subject(:result) { described_class.call(user_id: user.id, include_hidden: true) }

      it 'sets hidden column as false' do
        expect(result.find_by(id: hidden_item_by_other_user.id).hidden).to be false
      end
    end
  end
end
