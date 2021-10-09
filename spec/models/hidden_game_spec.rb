# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HiddenGame, type: :model do
  describe 'Relations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:game) }
  end

  describe 'Validations' do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:game_id) }

    it do
      wishlist_game = create(:wishlist_game)
      expect(wishlist_game).to validate_uniqueness_of(:game_id).scoped_to(:user_id).case_insensitive
    end
  end
end
