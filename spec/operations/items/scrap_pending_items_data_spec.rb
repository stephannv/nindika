# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::ScrapPendingItemsData, type: :operations do
  describe 'Inputs' do
    subject { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe '#call' do
    subject(:result) { described_class.result }

    let(:pending_scrap) { instance_double(ActiveRecord::Relation) }
    let(:item_a) { Item.new }
    let(:item_b) { Item.new }

    before do
      allow(Item).to receive(:pending_scrap).and_return(pending_scrap)
      allow(pending_scrap).to receive(:find_each).with(batch_size: 200).and_yield(item_a).and_yield(item_b)
    end

    it 'scraps data for each pending scrap item' do
      [item_a, item_b].each { |i| expect(Items::ScrapData).to receive(:call).with(item: i) }

      result
    end

    context 'when some error happens on development environment' do
      let(:error) { StandardError.new('some error') }

      before do
        allow(Rails.env).to receive(:development?).and_return(true)
        allow(Items::ScrapData).to receive(:call).and_raise(error)
      end

      it 'raises error' do
        expect { result }.to raise_error(error)
      end
    end

    context 'when some error happens on not development environment' do
      let(:error) { StandardError.new('some error') }

      before do
        allow(Rails.env).to receive(:development?).and_return(false)
        allow(Items::ScrapData).to receive(:call).and_raise(error)
      end

      it 'handles error with Sentry' do
        expect(Sentry).to receive(:capture_exception).with(error, extra: { item_id: item_a.id }).twice

        result
      end
    end
  end
end
