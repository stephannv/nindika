# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::Update, type: :actions do
  describe 'Inputs' do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(id: { type: String }) }
    it { is_expected.to include(attributes: { type: Hash }) }
  end

  describe 'Outputs' do
    subject { described_class.outputs }

    it { is_expected.to include(item: { type: Item }) }
  end

  describe '#call' do
    subject(:result) { described_class.result(id: item.id, attributes: attributes) }

    let(:item) { create(:item) }

    context 'when attributes are valid' do
      let(:attributes) { { title: 'new title' } }

      it { is_expected.to be_success }

      it 'updates item with new attributes' do
        expect(result.item.reload.attributes).to include(
          'id' => item.id,
          'title' => 'new title'
        )
      end
    end

    context 'when attributes are invalid' do
      let(:attributes) { { title: nil } }

      it 'raises ActiveRecord::RecordInvalid error' do
        expect { result }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
