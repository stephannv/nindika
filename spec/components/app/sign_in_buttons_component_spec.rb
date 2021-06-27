# frozen_string_literal: true

require 'rails_helper'

RSpec.describe App::SignInButtonsComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new(current_user: user)) }

  context 'when user is logged in' do
    let(:user) { build(:user) }

    it 'doesn`t render' do
      expect(rendered.to_html).to be_blank
    end
  end

  context 'when user isn`t logged in' do
    let(:user) { nil }

    it 'renders buttons' do
      expect(rendered.to_html).to be_present
    end
  end
end
