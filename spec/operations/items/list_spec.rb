# frozen_string_literal: true

require "rails_helper"

RSpec.describe Items::List, type: :operations do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(sort_param: { type: String, default: nil, allow_nil: true }) }

    it do
      filters_form = inputs.dig(:filters_form, :default).call
      expect(filters_form).to be_a(GameFiltersForm)
    end
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to include(items: { type: Enumerable }) }
  end

  describe "#call" do
    context "when filter params is present" do
      let!(:item_on_sale) { create(:item, on_sale: true) }
      let(:filters_form) { GameFiltersForm.build(on_sale: true) }

      before { create(:item, on_sale: false) }

      it "filters items" do
        result = described_class.result(filters_form: filters_form)

        expect(result.items.to_a).to eq [item_on_sale]
      end
    end

    context "when sort param is present" do
      let!(:item_a) { create(:item, release_date: Time.zone.today) }
      let!(:item_b) { create(:item, release_date: Time.zone.tomorrow) }
      let!(:item_c) { create(:item, release_date: Time.zone.yesterday) }

      it "sorts items" do
        result = described_class.result(sort_param: "release_date_asc")

        expect(result.items.to_a).to eq [item_c, item_a, item_b]
      end
    end
  end
end
