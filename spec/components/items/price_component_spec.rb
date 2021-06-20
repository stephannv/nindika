# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::PriceComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(price)) }

  context 'when price is nil' do
    let(:price) { nil }

    it 'renders blank message' do
      content = rendered.css('span.fs-6.fw-bold.badge.bg-light.text-dark').to_html
      expect(content).to include(I18n.t('items.price_component.blank'))
    end
  end

  context 'when price has discount' do
    let(:price) { build(:price, :with_discount, item: Item.new(slug: 'abc')) }

    it 'renders regular amount with line through decoration' do
      content = rendered.css('span.text-decoration-line-through').to_html
      expect(content).to include(price.regular_amount.formatted)
    end

    it 'renders discount amount inside primary colored badge' do
      content = rendered.css('span.fs-6.fw-bold.badge.bg-primary').to_html

      expect(content).to include(price.discount_amount.formatted)
    end
  end

  context 'when price doesn`t have discount' do
    let(:price) { build(:price, item: Item.new(slug: 'abc')) }

    it 'renders regular amount inside dark colored badge' do
      content = rendered.css('span.fs-6.fw-bold.badge.bg-dark').to_html

      expect(content).to include(price.regular_amount.formatted)
    end
  end
end
