# frozen_string_literal: true

Rails.application.config.i18n.load_path += Dir[Rails.root.join("config/locales/**/*.{rb,yml}")]
Rails.application.config.i18n.available_locales = %i[en pt-BR]
Rails.application.config.i18n.default_locale = :"pt-BR"
