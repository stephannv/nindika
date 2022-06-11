# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::HorizontalListComponent, type: :component do
  subject(:rendered) do
    render_inline(
      described_class.new(
        title: "Some title",
        items: create_list(:item, 4),
        see_all_href: "https://example.com",
        cards_size: "uk-width-5-6"
      )
    )
  end

  it "renders without problems" do
    expect(rendered.to_html).to be_present
  end
end
