# frozen_string_literal: true

class PlausibleClient
  include HTTParty

  base_uri "https://analytics.nindika.com/api/v1"
  headers "Authorization" => "Bearer #{Rails.application.credentials.plausible_api_key}"
  default_params site_id: "nindika.com"

  def stats_grouped_by_page(period:, page:, limit:)
    date = "#{period.first.to_date.iso8601},#{period.last.to_date.iso8601}"
    query = { property: "event:page", period: "custom", date: date, page: page, limit: limit }
    response = self.class.get("/stats/breakdown", query: query)

    response.parsed_response["results"]
  end
end
