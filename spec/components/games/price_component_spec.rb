# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::PriceComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(game: game)) }

  let(:game) { Item.new(slug: 'abc', price: price) }

  context 'when price is nil' do
    let(:price) { nil }

    it 'renders blank message' do
      content = rendered.css('a.badge').to_html
      expect(content).to include(I18n.t('games.price_component.blank'))
    end
  end

  context 'when price has discount' do
    let(:price) { build(:price, :with_discount) }

    it 'renders percentage discount' do
      content = rendered.css('span.badge.bg-dark.text-white').to_html

      expect(content).to include(price.discount_percentage.to_s)
    end

    it 'renders discount amount inside primary colored badge' do
      content = rendered.css('span.badge.badge-primary.font-weight-bold').to_html

      expect(content).to include(price.discount_amount.formatted)
    end
  end

  context 'when price doesn`t have discount' do
    let(:price) { build(:price) }

    it 'renders regular amount inside dark colored badge' do
      content = rendered.css('a.badge').to_html

      expect(content).to include(price.regular_amount.formatted)
    end
  end
end
