# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Extensions::Money, type: :extension do
  describe '#formatted' do
    context 'when amount is zero' do
      it 'returns `free` word' do
        money = Money.new(0, 'BRL')

        expect(money.formatted).to eq I18n.t('free')
      end
    end

    context 'when amount is greater than zero' do
      it 'returns symbol + amount' do
        money = Money.new(1000, 'BRL')

        expect(money.formatted).to eq 'R$ 10,00'
      end
    end

    context 'when integer is true' do
      it 'returns symbol + amount as integer' do
        money = Money.new(1296, 'BRL')

        expect(money.formatted(integer: true)).to eq 'R$ 12'
      end
    end
  end
end
