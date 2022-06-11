# frozen_string_literal: true

require "rails_helper"

RSpec.describe WishlistItem, type: :model do
  describe "Relations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:item) }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:user_id) }
    it { is_expected.to validate_presence_of(:item_id) }

    it do
      wishlist_item = create(:wishlist_item)
      expect(wishlist_item).to validate_uniqueness_of(:item_id).scoped_to(:user_id).case_insensitive
    end
  end
end
