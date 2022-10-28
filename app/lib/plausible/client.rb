# frozen_string_literal: true

module Plausible
  class Client
    include HTTParty

    attr_reader :api_url, :default_headers, :default_params

    def initialize
      @api_url = Rails.application.credentials.plausible_api_url
      @default_headers = { "Authorization" => "Bearer #{Rails.application.credentials.plausible_api_key}" }
      @default_params = { site_id: Rails.application.credentials.plausible_api_site_id }
    end

    def stats_grouped_by_page(period:, page:, limit:)
      query = build_query_params(period: period, page: page, limit: limit)
      response = self.class.get("#{api_url}/stats/breakdown", query: query, headers: default_headers)

      response.parsed_response["results"]
    end

    private

    def build_query_params(period:, page:, limit:)
      date = "#{period.first.to_date.iso8601},#{period.last.to_date.iso8601}"
      default_params.merge(
        {
          property: "event:page",
          period: "custom",
          date: date,
          page: page,
          limit: limit
        }
      )
    end
  end
end
