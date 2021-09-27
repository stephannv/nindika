# frozen_string_literal: true

class App
  extend Dry::Configurable

  setting :app_domain, default: 'https://nindika.com'
end
