# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::PriceComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(game: game)) }

  let(:game) { Item.new(slug: 'abc', price: price) }

  context 'when price is nil' do
    let(:price) { nil }

    it 'renders blank message' do
      content = rendered.css('.font-size-12.font-weight-medium').to_html
      expect(content).to include(I18n.t('games.price_component.blank'))
    end
  end

  context 'when price has discount' do
    let(:price) { build(:price, :with_discount) }

    it 'renders discount percentage' do
      content = rendered.css('code.code').to_html

      expect(content).to include(price.discount_percentage.to_s)
    end

    it 'renders discount price using Prices::LabelComponent' do
      content = rendered.to_html
      discount_price = render_inline(Prices::LabelComponent.new(money: price.discount_price)).to_html

      expect(content).to include(discount_price)
    end

    it 'renders base price using Prices::LabelComponent with line_through option' do
      content = rendered.to_html
      base_price = render_inline(Prices::LabelComponent.new(money: price.base_price, line_through: true)).to_html

      expect(content).to include(base_price)
    end
  end

  context 'when price doesn`t have discount' do
    let(:price) { build(:price) }

    it 'renders base price inside dark colored badge' do
      content = rendered.to_html
      base_price = render_inline(Prices::LabelComponent.new(money: price.base_price)).to_html

      expect(content).to include(base_price)
    end
  end
end
