# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::List::FilterComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(**parameters)) }

  let(:parameters) do
    {
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
