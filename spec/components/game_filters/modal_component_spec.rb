# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameFilters::ModalComponent, type: :component do
  subject(:rendered) do
    component = described_class.new(
      filters_form: GameFiltersForm.build,
      current_user: User.new,
      genres: ['action'],
      languages: ['PT']
    )
    render_inline(component)
  end

  it 'renders without problems' do
    with_request_url '/games' do
      expect(rendered.to_html).to be_present
    end
  end
end
