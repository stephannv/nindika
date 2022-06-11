# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventDispatch, type: :model do
  describe "Relations" do
    it { is_expected.to belong_to :item_event }
  end

  describe "Configurations" do
    it "has state enum" do
      expect(described_class.enumerations).to include(provider: EventDispatchProviders)
    end
  end

  describe "Validations" do
    it { is_expected.to validate_presence_of(:item_event_id) }
    it { is_expected.to validate_presence_of(:provider) }
  end

  describe "Scopes" do
    describe ".pending" do
      it "returns not sent dispatches" do
        not_imported_dispatch = create(:event_dispatch)
        create(:event_dispatch, :sent)
        expect(described_class.pending).to match_array [not_imported_dispatch]
      end
    end
  end
end
