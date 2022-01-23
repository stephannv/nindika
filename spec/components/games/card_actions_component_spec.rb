# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Games::CardActionsComponent, type: :component do
  subject(:rendered) do
    render_inline(described_class.new(game: build(:item, id: Faker::Internet.uuid), current_user: user))
  end

  context 'when non-admin user is logged in' do
    let(:user) { build(:user) }

    it 'doesn`t render' do
      expect(rendered.to_html).to be_blank
    end
  end

  context 'when admin user is logged in' do
    let(:user) { build(:user, :admin) }

    it 'renders content' do
      expect(rendered.to_html).to be_present
    end
  end

  context 'when user is a guest' do
    let(:user) { nil }

    it 'doesn`t render' do
      expect(rendered.to_html).to be_blank
    end
  end
end
