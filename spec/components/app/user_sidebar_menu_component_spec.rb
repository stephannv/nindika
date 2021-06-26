# frozen_string_literal: true

require 'rails_helper'

RSpec.describe App::UserSidebarMenuComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(user)) }

  context 'when user is logged in' do
    let(:user) { build(:user) }

    it 'renders content' do
      expect(rendered.to_html).to be_present
    end
  end

  context 'when user isn`t logged in' do
    let(:user) { nil }

    it 'doesn`t render' do
      expect(rendered.to_html).to be_blank
    end
  end
end
