# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Relations' do
    it { is_expected.to have_many(:wishlist_items).dependent(:destroy) }

    it { is_expected.to have_many(:wishlist).through(:wishlist_items).source(:item) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:provider) }
    it { is_expected.to validate_presence_of(:uid) }

    it do
      user = create(:user)
      expect(user).to validate_uniqueness_of(:uid).scoped_to(:provider)
    end
  end
end
