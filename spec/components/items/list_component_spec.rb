# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::ListComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(**parameters)) }

  let(:parameters) do
    {
      items: build_list(:item, 5),
      pagy: Pagy.new(count: 103, items: 10, size: [3, 2, 2, 3]),
      filters_form_object: GameFiltersForm.new,
      genres: [{ "some" => "genre" }],
      languages: %w[pt en fr]
    }
  end

  it "renders without problems" do
    with_request_url "/games" do
      expect(rendered.to_html).to be_present
    end
  end
end
