# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HiddenItems::Create, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(user: { type: User }) }
    it { is_expected.to include(item_id: { type: String }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(hidden_item: { type: HiddenItem }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(user: user, item_id: item.id) }

    let(:user) { create(:user) }
    let(:item) { create(:item) }

    context 'when attributes are valid' do
      it { is_expected.to be_success }

      it 'adds item to user hidden list' do
        result

        expect(user.hidden_list.exists?(id: item.id)).to eq true
      end
    end

    context 'when attributes are invalid' do
      let(:item) { Item.new(id: Faker::Internet.uuid) }

      it { is_expected.to be_failure }

      it 'doesn`t add item to user hidden list' do
        result

        expect(user.hidden_list.exists?(id: item.id)).to eq false
      end
    end
  end
end
