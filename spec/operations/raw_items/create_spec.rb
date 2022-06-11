# frozen_string_literal: true

require "rails_helper"

RSpec.describe RawItems::Create, type: :action do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to include(raw_items_data: { type: Array }) }
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe "#call" do
    subject(:result) { described_class.result(raw_items_data: [data]) }

    context "with new raw item data" do
      let(:data) { Faker::Types.rb_hash(number: 4).merge(objectID: Faker::Internet.uuid) }

      it "creates new raw item" do
        expect { result }.to change(RawItem, :count).by(1)
      end

      it "creates raw item with external_id, data, checksum and imported values" do
        result

        expect(RawItem.last.attributes).to include(
          "external_id" => data[:objectID],
          "data" => data.stringify_keys,
          "imported" => false,
          "checksum" => Digest::MD5.hexdigest(data.to_s),
          "item_id" => nil
        )
      end
    end

    context "with modified raw item data" do
      let!(:raw_item) { create(:raw_item, :with_item, imported: true) }
      let(:data) { Faker::Types.rb_hash(number: 4).merge(objectID: raw_item.external_id) }

      it "doesn`t create a raw item" do
        expect { result }.not_to change(RawItem, :count)
      end

      it "updates raw item data" do
        result

        expect(raw_item.reload.attributes).to include(
          "external_id" => data[:objectID],
          "data" => data.stringify_keys,
          "imported" => false,
          "checksum" => Digest::MD5.hexdigest(data.to_s),
          "item_id" => raw_item.item_id
        )
      end
    end

    context "with not modified raw item data" do
      let!(:raw_item) { create(:raw_item, :with_item, imported: true) }
      let(:data) { raw_item.data.symbolize_keys }

      it "doesn`t create a raw item" do
        expect { result }.not_to change(RawItem, :count)
      end

      it "doesn`t update raw item data" do
        result

        expect(RawItem.find(raw_item.id).attributes).to include(
          "external_id" => raw_item.external_id,
          "data" => raw_item.data,
          "imported" => true,
          "checksum" => raw_item.checksum,
          "item_id" => raw_item.item_id
        )
      end
    end

    context "when some error happens on development environment" do
      let(:data) { Faker::Types.rb_hash(number: 4).merge(objectID: Faker::Internet.uuid) }
      let(:error) { StandardError.new("some error") }

      before do
        allow(Rails.env).to receive(:development?).and_return(true)
        allow(RawItem).to receive(:find_or_initialize_by).and_raise(error)
      end

      it "raises error" do
        expect { result }.to raise_error(error)
      end
    end

    context "when some error happens on not development environment" do
      let(:data) { Faker::Types.rb_hash(number: 4).merge(objectID: Faker::Internet.uuid) }
      let(:error) { StandardError.new("some error") }

      before do
        allow(Rails.env).to receive(:development?).and_return(false)
        allow(RawItem).to receive(:find_or_initialize_by).and_raise(error)
      end

      it "handles error with Sentry" do
        expect(Sentry).to receive(:capture_exception).with(error, extra: { data: data })

        result
      end
    end
  end
end
