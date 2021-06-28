# frozen_string_literal: true

require 'rails_helper'

RSpec.describe App::ToastComponent, type: :component do
  subject(:rendered) { render_inline(described_class.new) }

  context 'when flash is empty' do
    it "doesn't render" do
      expect(rendered.to_html).to be_blank
    end
  end

  context 'when flash is filled' do
    subject(:rendered) { render_inline(component) }

    let(:component) { described_class.new }
    let(:flash) { ActionDispatch::Flash::FlashHash.new }

    before do
      flash[:danger] = 'some message'
      allow(component).to receive(:helpers).and_return(double(flash: flash)) # rubocop:disable RSpec/VerifiedDoubles
    end

    it 'renders component' do
      expect(rendered.to_html).to be_present
    end
  end
end
