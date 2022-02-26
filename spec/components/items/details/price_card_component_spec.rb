# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::Details::PriceCardComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(item: build(:item, price: price))) }

  context 'with free item' do
    let(:price) { build(:price, base_price: 0) }

    it 'renders without problems' do
      expect(rendered.to_html).to be_present
    end
  end

  context 'with paid item' do
    let(:price) { build(:price, base_price: 10) }

    it 'renders without problems' do
      expect(rendered.to_html).to be_present
    end
  end
end
