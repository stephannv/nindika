# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ItemEvent, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:item) }

    it { is_expected.to have_many(:dispatches).class_name('EventDispatch').dependent(:destroy) }
  end

  describe 'Configurations' do
    it 'has event_type enum' do
      expect(described_class.enumerations).to include(event_type: ItemEventTypes)
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:item_id) }
    it { is_expected.to validate_presence_of(:title) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:event_type) }
  end
end
