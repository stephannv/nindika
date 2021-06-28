# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::WithoutHiddenQuery, type: :query do
  subject(:result) { described_class.call(user_id: user.id) }

  describe '#call' do
    let(:user) { create(:user) }
    let!(:other_items) { create_list(:item, 5) }
    let!(:hidden_item_by_other_user) { create(:hidden_item).item }

    before { create(:hidden_item, user: user).item }

    it 'returns all items but hidden items by given user' do
      expect(result.to_a).to eq [other_items, hidden_item_by_other_user].flatten
    end
  end
end
