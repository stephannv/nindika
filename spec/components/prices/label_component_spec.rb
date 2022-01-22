# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Prices::LabelComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(money: money)) }

  context 'when money is zero' do
    let(:money) { Money.new(0, 'BRL') }

    it 'returns `free` label' do
      expect(rendered.to_html).to eq I18n.t('free')
    end
  end

  context 'when line through is true' do
    subject(:rendered) { render_inline(described_class.new(money: Money.new(100, 'BRL'), line_through: true)) }

    it 'returns value inside <s> tag' do
      expect(rendered.to_html).to eq '<sup>R$</sup><s>1</s>'
    end
  end

  context 'when value is greater than or equal to 100 cents' do
    let(:money) { Money.new(1265, 'BRL') }

    it 'renders value as integer' do
      expect(rendered.to_html).to eq '<sup>R$</sup>12'
    end
  end

  context 'when value is lower than 100 cents' do
    let(:money) { Money.new(85, 'BRL') }

    it 'renders value as decimal' do
      expect(rendered.to_html).to eq '<sup>R$</sup>0,85'
    end
  end
end
