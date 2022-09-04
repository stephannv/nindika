# frozen_string_literal: true

require "rails_helper"

# rubocop:disable Style/ClassVars
RSpec.describe Settings, type: :initializer do
  describe ".enable_analytics?" do
    context "when plausible_data_domain credential is blank" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_analytics, nil)
        allow(Rails.application.credentials).to receive(:plausible_data_domain).and_return(nil)
        allow(Rails.application.credentials).to receive(:plausible_src).and_return("value")

        expect(described_class.enable_analytics?).to be false
      end
    end

    context "when plausible_src credential is blank" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_analytics, nil)
        allow(Rails.application.credentials).to receive(:plausible_data_domain).and_return("value")
        allow(Rails.application.credentials).to receive(:plausible_src).and_return(nil)

        expect(described_class.enable_analytics?).to be false
      end
    end

    context "when plausible_data_domain and plausible_src credential are present" do
      it "returns true" do
        described_class.class_variable_set(:@@enable_analytics, nil)
        allow(Rails.application.credentials).to receive(:plausible_data_domain).and_return("value")
        allow(Rails.application.credentials).to receive(:plausible_src).and_return("value")

        expect(described_class.enable_analytics?).to be true
      end
    end
  end

  describe ".enable_telegram_notifications?" do
    context "when telegram_channel_id credential is blank" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_telegram_notifications, nil)
        allow(Rails.application.credentials).to receive(:telegram_channel_id).and_return(nil)
        allow(Rails.application.credentials).to receive(:telegram_bots).and_return("value")

        expect(described_class.enable_telegram_notifications?).to be false
      end
    end

    context "when telegram_bots credential is blank" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_telegram_notifications, nil)
        allow(Rails.application.credentials).to receive(:telegram_channel_id).and_return("value")
        allow(Rails.application.credentials).to receive(:telegram_bots).and_return(nil)

        expect(described_class.enable_telegram_notifications?).to be false
      end
    end

    context "when telegram_channel_id and telegram_bots credential are present" do
      it "returns true" do
        described_class.class_variable_set(:@@enable_telegram_notifications, nil)
        allow(Rails.application.credentials).to receive(:telegram_channel_id).and_return("value")
        allow(Rails.application.credentials).to receive(:telegram_bots).and_return("value")

        expect(described_class.enable_telegram_notifications?).to be true
      end
    end
  end

  describe ".enable_analytics_import?" do
    context "when plausible_api_key credential is blank" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_analytics_import, nil)
        allow(Rails.application.credentials).to receive(:plausible_api_key).and_return(nil)

        expect(described_class.enable_analytics_import?).to be false
      end
    end

    context "when plausible_api_key is present" do
      it "returns true" do
        described_class.class_variable_set(:@@enable_analytics_import, nil)
        allow(Rails.application.credentials).to receive(:plausible_api_key).and_return("value")

        expect(described_class.enable_analytics_import?).to be true
      end
    end
  end

  describe ".enable_twitter_sign_in?" do
    context "when twitter_app_id credential is blank" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_twitter_sign_in, nil)
        allow(Rails.application.credentials).to receive(:twitter_app_id).and_return(nil)
        allow(Rails.application.credentials).to receive(:twitter_app_secret).and_return("value")

        expect(described_class.enable_twitter_sign_in?).to be false
      end
    end

    context "when twitter_app_secret credential is blank" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_twitter_sign_in, nil)
        allow(Rails.application.credentials).to receive(:twitter_app_id).and_return("value")
        allow(Rails.application.credentials).to receive(:twitter_app_secret).and_return(nil)

        expect(described_class.enable_twitter_sign_in?).to be false
      end
    end

    context "when twitter_app_id and twitter_app_secret credential are present" do
      it "returns true" do
        described_class.class_variable_set(:@@enable_twitter_sign_in, nil)
        allow(Rails.application.credentials).to receive(:twitter_app_id).and_return("value")
        allow(Rails.application.credentials).to receive(:twitter_app_secret).and_return("value")

        expect(described_class.enable_twitter_sign_in?).to be true
      end
    end
  end

  describe ".enable_discord_sign_in?" do
    context "when discord_app_id credential is blank" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_discord_sign_in, nil)
        allow(Rails.application.credentials).to receive(:discord_app_id).and_return(nil)
        allow(Rails.application.credentials).to receive(:discord_app_secret).and_return("value")

        expect(described_class.enable_discord_sign_in?).to be false
      end
    end

    context "when discord_app_secret credential is blank" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_discord_sign_in, nil)
        allow(Rails.application.credentials).to receive(:discord_app_id).and_return("value")
        allow(Rails.application.credentials).to receive(:discord_app_secret).and_return(nil)

        expect(described_class.enable_discord_sign_in?).to be false
      end
    end

    context "when discord_app_id and discord_app_secret credential are present" do
      it "returns true" do
        described_class.class_variable_set(:@@enable_discord_sign_in, nil)
        allow(Rails.application.credentials).to receive(:discord_app_id).and_return("value")
        allow(Rails.application.credentials).to receive(:discord_app_secret).and_return("value")

        expect(described_class.enable_discord_sign_in?).to be true
      end
    end
  end

  describe ".enable_dev_sign_in?" do
    context "when environment is development" do
      it "returns true" do
        described_class.class_variable_set(:@@enable_dev_sign_in, nil)
        allow(Rails.env).to receive(:development?).and_return(true)
        allow(Rails.env).to receive(:test?).and_return(false)
        allow(Rails.env).to receive(:production?).and_return(false)

        expect(described_class.enable_dev_sign_in?).to be true
      end
    end

    context "when environment is test" do
      it "returns true" do
        described_class.class_variable_set(:@@enable_dev_sign_in, nil)
        allow(Rails.env).to receive(:development?).and_return(false)
        allow(Rails.env).to receive(:test?).and_return(true)
        allow(Rails.env).to receive(:production?).and_return(false)

        expect(described_class.enable_dev_sign_in?).to be true
      end
    end

    context "when environment is production" do
      it "returns false" do
        described_class.class_variable_set(:@@enable_dev_sign_in, nil)
        allow(Rails.env).to receive(:development?).and_return(false)
        allow(Rails.env).to receive(:test?).and_return(false)
        allow(Rails.env).to receive(:production?).and_return(true)

        expect(described_class.enable_dev_sign_in?).to be false
      end
    end
  end
end
# rubocop:enable Style/ClassVars
