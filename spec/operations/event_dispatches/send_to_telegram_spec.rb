# frozen_string_literal: true

require "rails_helper"

RSpec.describe EventDispatches::SendToTelegram, type: :operations do
  include ActiveSupport::Testing::TimeHelpers

  describe "Inputs" do
    subject(:inputs) { described_class.inputs }

    it "injects Telegram client" do
      default = inputs.dig(:client, :default).call

      expect(default).to be_a(TelegramClient)
    end
  end

  describe "Outputs" do
    subject { described_class.outputs }

    it { is_expected.to be_empty }
  end

  describe "#call" do
    subject(:result) { described_class.result(client: client) }

    let(:client) { TelegramClient.new }
    let(:telegram_response) { { "ok" => true } }

    before do
      allow_any_instance_of(described_class).to receive(:sleep) # rubocop:disable RSpec/AnyInstance
      allow(client).to receive(:send_message).and_return(telegram_response)
      allow(Rails.application.credentials).to receive(:telegram_bots).and_return(%w[botA botB botC])
      allow(Rails.application.credentials).to receive(:telegram_channel_id).and_return("ChannelID")
    end

    context "when telegram notifications are not enabled" do
      it "fails" do
        allow(Settings).to receive(:enable_telegram_notifications?).and_return(false)

        result = described_class.result(client: TelegramClient.new)

        expect(result).to be_failure
      end

      it "doesn't send telegram notifications" do
        allow(Settings).to receive(:enable_telegram_notifications?).and_return(false)
        client = TelegramClient.new

        expect(client).not_to receive(:send_message)

        described_class.result(client: client)
      end
    end

    context "when message is sent with success" do
      let(:now) { Time.zone.now }

      before do
        create_list(:event_dispatch, 5, :telegram)
        travel_to now
      end

      it "marks event dispatch as sent" do
        expect { result }.to change(EventDispatch.telegram.pending, :count).by(-5)
      end
    end

    context "when event dispatch is pending" do
      let!(:event_dispatch) { create(:event_dispatch, :telegram) }
      let(:text) { TelegramEventTextBuilder.build(item_event: event_dispatch.item_event) }

      it "sends message" do
        expect(client).to receive(:send_message).with(chat_id: "ChannelID", bot_token: "botA", text: text)

        result
      end
    end

    context "when event dispatch isn`t pending" do
      before { create(:event_dispatch, :telegram, :sent) }

      it "doesn`t send message" do
        expect(client).not_to receive(:send_message)

        result
      end
    end

    context "when there are multiple pending dispatches" do
      before { create_list(:event_dispatch, 5, :telegram) }

      it "sends message rotating bot tokens" do
        %w[botA botB botC botA botB].each do |bot_token|
          expect(client).to receive(:send_message)
            .with(chat_id: "ChannelID", bot_token: bot_token, text: an_instance_of(String))
        end

        result
      end
    end

    context "when there are multiple pending dispatches for same item" do
      let(:item) { create(:item) }
      let(:event_dispatch_a) do
        create(:event_dispatch, :telegram, item_event: create(:item_event, :price_added, item: item))
      end
      let(:event_dispatch_b) do
        create(:event_dispatch, :telegram, item_event: create(:item_event, :item_added, item: item))
      end

      it "groups dispatches into single text message" do
        text_a = TelegramEventTextBuilder.build(item_event: event_dispatch_a.item_event)
        text_b = TelegramEventTextBuilder.build(item_event: event_dispatch_b.item_event)

        expect(client).to receive(:send_message)
          .with(chat_id: "ChannelID", bot_token: "botA", text: "#{text_b}\n\n#{text_a}")

        result
      end
    end

    it "sleeps 1 second between dispatches" do
      create_list(:event_dispatch, 5, :telegram)
      expect_any_instance_of(described_class).to receive(:sleep).exactly(5).times # rubocop:disable RSpec/AnyInstance

      result
    end

    context "when message cannot be sent" do
      let(:telegram_response) { { "ok" => false, "some info" => "info" } }

      before do
        create(:event_dispatch, :telegram)
      end

      it "captures message with Sentry" do
        expect(Sentry).to receive(:capture_message)
          .with("Cannot send telegram notifications", extra: telegram_response)

        result
      end

      it "doesn`t mark event dispatch as sent" do
        expect { result }.not_to change(EventDispatch.telegram.pending, :count)
      end
    end

    context "when unexpected error happens" do
      let(:error) { StandardError.new("some error") }

      before do
        create(:event_dispatch, :telegram)
        allow(client).to receive(:send_message).and_raise(error)
      end

      it "handles error with Sentry" do
        expect(Sentry).to receive(:capture_exception).with(error, extra: { dispatches: instance_of(Array) })

        result
      end
    end
  end
end
