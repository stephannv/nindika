# frozen_string_literal: true

require "rails_helper"

RSpec.describe GameFiltersForm, type: :lib do
  describe "Attributes" do
    subject(:attributes) { described_class.attribute_types }

    let(:expected_attributes) do
      {
        title: an_instance_of(ActiveModel::Type::String),
        genre: an_instance_of(ActiveModel::Type::String),
        language: an_instance_of(ActiveModel::Type::String),
        release_date_gteq: an_instance_of(ActiveModel::Type::Date),
        release_date_lteq: an_instance_of(ActiveModel::Type::Date),
        price_gteq: an_instance_of(ActiveModel::Type::Integer),
        price_lteq: an_instance_of(ActiveModel::Type::Integer),
        on_sale: an_instance_of(ActiveModel::Type::Boolean),
        new_release: an_instance_of(ActiveModel::Type::Boolean),
        coming_soon: an_instance_of(ActiveModel::Type::Boolean),
        pre_order: an_instance_of(ActiveModel::Type::Boolean),
        wishlisted: an_instance_of(ActiveModel::Type::Boolean)
      }.stringify_keys
    end

    it { is_expected.to match expected_attributes }
  end

  describe ".build" do
    it "returns a new form with given attributes filled" do
      form = described_class.build(title: "zelda")
      expect(form.title).to eq "zelda"
    end
  end

  describe "#release_date_range?" do
    context "when release_date_gteq is present" do
      subject(:form) { described_class.build(release_date_gteq: Time.zone.today) }

      it "returns true" do
        expect(form.release_date_range?).to be true
      end
    end

    context "when release_date_lteq is present" do
      subject(:form) { described_class.build(release_date_lteq: Time.zone.today) }

      it "returns true" do
        expect(form.release_date_range?).to be true
      end
    end

    context "when release_date_gteq and release_date_lteq are blank" do
      subject(:form) { described_class.build }

      it "returns false" do
        expect(form.release_date_range?).to be false
      end
    end
  end

  describe "#release_date_range" do
    subject(:form) { described_class.build(release_date_gteq: Time.zone.yesterday) }

    it "returns a range using release_date_gteq and release_date_lteq" do
      expect(form.release_date_range).to cover(Time.zone.tomorrow)
    end
  end

  describe "#price_range?" do
    context "when price_gteq is present" do
      subject(:form) { described_class.build(price_gteq: 10) }

      it "returns true" do
        expect(form.price_range?).to be true
      end
    end

    context "when price_lteq is present" do
      subject(:form) { described_class.build(price_lteq: 10) }

      it "returns true" do
        expect(form.price_range?).to be true
      end
    end

    context "when price_gteq and price_lteq are blank" do
      subject(:form) { described_class.build }

      it "returns false" do
        expect(form.price_range?).to be false
      end
    end
  end

  describe "#price_cents_range" do
    subject(:form) { described_class.build(price_gteq: 9) }

    it "returns a range using price_gteq cents and price_lteq cents" do
      expect(form.price_cents_range).to cover(950)
    end
  end
end
