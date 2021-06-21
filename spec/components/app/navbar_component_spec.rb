# frozen_string_literal: true

require 'rails_helper'

RSpec.describe App::NavbarComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new) }

  it 'renders brand' do
    content = rendered.css('a.navbar-brand.fs-3.fw-bold.align-middle').to_html
    expect(content).to be_present
  end

  it 'renders games menu' do
    content = rendered.css('a.nav-link.fw-bold.fs-4.text-decoration-underline').to_html
    expect(content).to include(I18n.t('app.navbar_component.games'))
  end

  it 'renders notifications menu' do
    content = rendered.css('a.nav-link.fw-bold.fs-4.text-decoration-underline').to_html
    expect(content).to include(I18n.t('app.navbar_component.notifications'))
  end
end
