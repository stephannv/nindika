# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:subject) }
  end

  describe 'Configurations' do
    it 'has notification_type enum' do
      expect(described_class.enumerations).to include(notification_type: NotificationTypes)
    end
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:title) }
  end
end
