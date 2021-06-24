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
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(items: { type: Enumerable }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(filter_params: filter_params) }

    let!(:items) { create_list(:item, 5, :with_price) }
    let(:filter_params) { Faker::Types.rb_hash(number: 4) }

    before do
      allow(ItemsFilter).to receive(:apply)
        .with(kind_of(ActiveRecord::Relation), filter_params)
        .and_return(items)
    end

    it 'returns items with applied filters' do
      expect(result.items.to_a).to include(*items)
    end
  end
end
