# frozen_string_literal: true

require "rails_helper"

RSpec.describe Admin::ImportData, type: :operations do
  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it { is_expected.to be_empty }
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe "#call" do
    subject(:result) { described_class.result }

    let(:operations) do
      [
        RawItems::Import,
        Prices::Import,
        Items::UpdateFlags,
        EventDispatches::SendToTelegram
      ]
    end

    before do
      operations.each { |a| allow(a).to receive(:call) }
    end

    it "executes data import tasks" do
      expect(operations).to all(receive(:call).ordered)

      result
    end

    context "when some task raises error" do
      let(:error) { StandardError.new("some error") }

      before do
        allow(Rails.env).to receive(:development?).and_return(false)
        allow(Prices::Import).to receive(:call).and_raise(error)
      end

      it "handles error with Sentry" do
        expect(Sentry).to receive(:capture_exception).with(error, extra: { task: "Import prices" })

        result
      end
    end
  end
end
