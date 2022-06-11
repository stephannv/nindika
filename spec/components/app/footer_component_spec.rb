# frozen_string_literal: true

require "rails_helper"

RSpec.describe App::FooterComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new) }

  it "renders without problems" do
    expect(rendered.to_html).to be_present
  end
end
