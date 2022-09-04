# frozen_string_literal: true

# rubocop:disable Style/ClassVars
class Settings
  def self.enable_analytics?
    @@enable_analytics ||= Rails.application.credentials.plausible_data_domain.present? &&
      Rails.application.credentials.plausible_src.present?
  end

  def self.enable_sentry?
    @@enable_sentry ||= Rails.application.credentials.sentry_dsn.present?
  end

  def self.enable_telegram_notifications?
    @@enable_telegram_notifications ||= Rails.application.credentials.telegram_channel_id.present? &&
      Rails.application.credentials.telegram_bots.present?
  end

  def self.enable_analytics_import?
    @@enable_analytics_import ||= Rails.application.credentials.plausible_api_key.present? &&
      Rails.application.credentials.plausible_api_url.present? &&
      Rails.application.credentials.plausible_api_site_id.present?
  end

  def self.enable_twitter_sign_in?
    @@enable_twitter_sign_in ||= Rails.application.credentials.twitter_app_id.present? &&
      Rails.application.credentials.twitter_app_secret.present?
  end

  def self.enable_discord_sign_in?
    @@enable_discord_sign_in ||= Rails.application.credentials.discord_app_id.present? &&
      Rails.application.credentials.discord_app_secret.present?
  end

  def self.enable_dev_sign_in?
    @@enable_dev_sign_in ||= Rails.env.development? || Rails.env.test?
  end
end
# rubocop:enable Style/ClassVars
