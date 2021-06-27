# frozen_string_literal: true

require 'rails_helper'

RSpec.describe App::SidebarComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(current_user: build(:user))) }

  it 'renders brand' do
    content = rendered.css('a.sidebar-brand img').to_html
    expect(content).to be_present
  end

  it 'renders all games menu' do
    content = rendered.css('a.sidebar-link').to_html
    expect(content).to include(I18n.t('app.sidebar_component.all'))
  end

  it 'renders on sale games menu' do
    content = rendered.css('a.sidebar-link').to_html
    expect(content).to include(I18n.t('app.sidebar_component.on_sale'))
  end

  it 'renders new releases games menu' do
    content = rendered.css('a.sidebar-link').to_html
    expect(content).to include(I18n.t('app.sidebar_component.new_releases'))
  end

  it 'renders coming soon games menu' do
    content = rendered.css('a.sidebar-link').to_html
    expect(content).to include(I18n.t('app.sidebar_component.coming_soon'))
  end

  it 'renders pre order games menu' do
    content = rendered.css('a.sidebar-link').to_html
    expect(content).to include(I18n.t('app.sidebar_component.pre_order'))
  end
end
