# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::PriceWithCTAButtonComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(price: price)) }

  context 'when price is nil' do
    let(:price) { nil }

    it 'doesn`t render' do
      content = rendered.to_html
      expect(content).to be_blank
    end
  end

  context 'when price is zero' do
    let(:price) { build(:price, :with_discount, discount_price: Money.new(0, 'BRL')) }

    it 'renders without problem' do
      content = rendered.to_html
      expect(content).to be_present
    end
  end

  context 'when price has discount' do
    let(:price) { build(:price, :with_discount) }

    it 'renders without problem' do
      content = rendered.to_html
      expect(content).to be_present
    end
  end

  context 'when price doesn`t have discount' do
    let(:price) { build(:price) }

    it 'renders without problem' do
      content = rendered.to_html
      expect(content).to be_present
    end
  end
end
