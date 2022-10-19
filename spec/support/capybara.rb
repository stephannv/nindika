# frozen_string_literal: true

require "capybara/rails"
require "capybara/rspec"

RSpec.configure do |config|
  %i[views].each do |type|
    config.include Capybara::RSpecMatchers, type: type
  end
end
