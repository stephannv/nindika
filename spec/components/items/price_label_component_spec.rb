# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Items::PriceLabelComponent, type: :component do
  context 'when money is less than 100 cents' do
    subject(:rendered) { render_inline(described_class.new(money: Money.new(2, 'BRL'))) }

    it 'renders without problems' do
      expect(rendered.to_html).to be_present
    end
  end

  context 'when money is greater than 100 cents' do
    subject(:rendered) { render_inline(described_class.new(money: Money.new(200, 'BRL'))) }

    it 'renders without problems' do
      expect(rendered.to_html).to be_present
    end
  end
end
