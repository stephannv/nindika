# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::Details::InfoCardComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(item: build(:item))) }

  it "renders without problems" do
    expect(rendered.to_html).to be_present
  end
end
