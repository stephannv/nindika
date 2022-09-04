# frozen_string_literal: true

class VisitsCollector
  attr_reader :plausible_client

  def initialize(plausible_client: PlausibleClient.new)
    @plausible_client = plausible_client
  end

  def self.all_time_game_pages_stats(plausible_client: PlausibleClient.new)
    new(plausible_client: plausible_client).all_time_game_pages_stats
  end

  def self.last_week_game_pages_stats(plausible_client: PlausibleClient.new)
    new(plausible_client: plausible_client).last_week_game_pages_stats
  end

  def all_time_game_pages_stats
    stats = fetch_all(period: Date.parse("2021-06-01")..Time.zone.today)
    filter_game_stats(stats)
  end

  def last_week_game_pages_stats
    stats = fetch_all(period: 7.days.ago..Time.zone.today)
    filter_game_stats(stats)
  end

  private

  def fetch_all(period:)
    stats = []

    (1..).map do |page|
      data = plausible_client.stats_grouped_by_page(period: period, page: page, limit: 200)
      break if data.blank?

      stats += data
    end

    stats.flatten.compact
  end

  def filter_game_stats(stats)
    stats
      .select { |s| s["page"].start_with?(%r{/games?/}) } # filter paths starting with /game/ or /games/
      .each { |s| s["slug"] = s["page"].gsub(%r{/games?/}, "") } # extract game slug
  end
end
