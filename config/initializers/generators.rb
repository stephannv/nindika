# frozen_string_literal: true

Rails.application.config.generators do |g|
  g.factory_bot suffix: 'factories'
  g.fixture_replacement :factory_bot, dir: 'spec/factories'
  g.orm :active_record, primary_key_type: :uuid
  g.test_framework :rspec
  g.view_specs false
  g.helper false
  g.assets false
end
