# frozen_string_literal: true

if Rails.env.production?
  Sentry.init do |config|
    config.dsn = Rails.application.credentials.sentry_dsn
    config.breadcrumbs_logger = %i[active_support_logger http_logger]

    # Set tracesSampleRate to 1.0 to capture 100%
    # of transactions for performance monitoring.
    # We recommend adjusting this value in production
    config.traces_sample_rate = 0.2
  end
end
