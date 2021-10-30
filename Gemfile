# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.2'

gem 'algolia', '2.1.1'
gem 'awesome_print', '1.9.2'
gem 'bootsnap', '1.9.1', require: false
gem 'bytesize', '0.1.2'
gem 'down', '5.2.4'
gem 'dry-configurable', '0.13.0'
gem 'enumerate_it', '3.2.1'
gem 'friendly_id', '5.4.2'
gem 'grape', github: 'ruby-grape/grape', branch: 'master'
gem 'grape-entity', '0.10.0'
gem 'httparty', '0.19.0'
gem 'i18n_data', '0.13.0'
gem 'money-rails', '1.14.0'
gem 'nokogiri', '1.12.4'
gem 'omniauth', '2.0.4'
gem 'omniauth-discord', '1.0.2'
gem 'omniauth-rails_csrf_protection', '1.0.0'
gem 'omniauth-twitter', '1.4.0'
gem 'order_query', github: 'stephannv/order_query', branch: 'master'
gem 'pg', '1.2.3'
gem 'pg_search', '2.3.5'
gem 'puma', '5.5.0'
gem 'rack-cors', '1.1.1'
gem 'rails', '7.0.0.alpha2'
gem 'rails-i18n', '6.0.0'
gem 'sentry-rails', '4.7.3'
gem 'sentry-ruby', '4.7.3'
gem 'service_actor', '3.1.1'
gem 'tzinfo-data', '2.0.4', platforms: %i[mingw mswin x64_mingw jruby]

group :development, :test do
  gem 'byebug', '11.1.3', platforms: %i[mri mingw x64_mingw]
  # gem 'debug', '1.1.0', platforms: %i[mri mingw x64_mingw] # problem with iTerm 2 + zsh
  gem 'factory_bot_rails', '6.2.0'
  gem 'faker', '2.19.0'
end

group :development do
  gem 'rubocop', '1.21.0'
  gem 'rubocop-performance', '1.11.5'
  gem 'rubocop-rails', '2.12.2'
  gem 'rubocop-rspec', '2.5.0'
end

group :test do
  gem 'rspec-rails', '5.0.2'
  gem 'shoulda-matchers', '5.0.0'
  gem 'simplecov', '0.21.2'
  gem 'webmock', '3.14.0'
end
