# frozen_string_literal: true

require "json"
require "httparty"

module Nintendo
  class Client
    include HTTParty

    attr_reader :app_id, :app_key

    def initialize(
      app_id: Rails.application.credentials.nintendo_app_id,
      app_key: Rails.application.credentials.nintendo_app_key
    )
      @app_id = app_id
      @app_key = app_key
    end

    def list_items(requests:)
      response = self.class.post(api_endpoint, body: JSON.dump({ requests: requests }), headers: headers)
      JSON.parse(response.body)
    end

    def list_items_in_batches(requests: Nintendo::RequestsBuilder.build, batch_size: 20)
      requests.each_slice(batch_size) do |requests_batch|
        yield list_items(requests: requests_batch)
      end
    end

    private

    def api_endpoint
      @api_endpoint ||= "https://#{app_id.downcase}-dsn.algolia.net/1/indexes/*/queries"
    end

    def headers
      @headers ||= { "x-algolia-application-id" => app_id, "x-algolia-api-key" => app_key }
    end
  end
end
