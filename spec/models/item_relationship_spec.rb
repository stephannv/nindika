# frozen_string_literal: true

require "rails_helper"

RSpec.describe ItemRelationship, type: :model do
  describe "Relations" do
    it { is_expected.to belong_to(:parent).class_name("Item") }
    it { is_expected.to belong_to(:child).class_name("Item") }
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:parent_id) }
    it { is_expected.to validate_presence_of(:child_id) }

    it "enforces uniqueness on parent_id and child_id" do
      item_relationship = create(:item_relationship)

      expect(item_relationship).to validate_uniqueness_of(:child_id).scoped_to(:parent_id).case_insensitive
    end
  end
end
