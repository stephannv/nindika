# frozen_string_literal: true

module Nindika
  module V1
    class BaseAPI < Grape::API
      format :json
      version :v1, using: :path

      rescue_from Grape::Exceptions::ValidationErrors do |e|
        error!({ errors: e.full_messages }, 400)
      end

      rescue_from ActiveRecord::RecordNotFound do |e|
        error!({ error: e.message }, 404)
      end

      rescue_from :all do |e|
        raise e unless Rails.env.production?

        Sentry.capture_exception(e)

        error!({ error: 'Internal server error' }, 500)
      end

      mount Nindika::V1::GamesAPI
    end
  end
end
