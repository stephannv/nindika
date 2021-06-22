# frozen_string_literal: true

class NintendoAlgoliaDataAdapter
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def self.adapt(data)
    new(data).adapt
  end

  def adapt
    {
      title: title,
      description: description,
      external_id: external_id,
      release_date: release_date,
      release_date_display: release_date_display,
      website_url: website_url,
      boxart_url: boxart_url,
      banner_url: banner_url,
      nsuid: nsuid,
      genres: genres,
      franchises: franchises,
      developers: developers,
      publishers: publishers,
      extra: extra
    }
  end

  private

  def title
    data['title'].try(:tr, '®™', '')
  end

  def description
    data['description']
  end

  def release_date
    data['releaseDateDisplay'].to_date
  rescue StandardError
    Date.parse('31/12/2049')
  end

  def release_date_display
    data['releaseDateDisplay'].to_date.to_s
  rescue StandardError
    data['releaseDateDisplay'] || 'TBD'
  end

  def website_url
    "https://www.nintendo.com#{data['url']}"
  end

  def boxart_url
    url = data['boxart'] || data['horizontalHeaderImage'] || 'https://via.placeholder.com/540x360?text=nindika'
    url = "https://www.nintendo.com#{url}" unless url.start_with?('http')
    NintendoImageTransformer.medium(url)
  end

  def banner_url
    return if data['horizontalHeaderImage'].blank?

    url = data['horizontalHeaderImage']
    url = "https://www.nintendo.com#{url}" unless url.start_with?('http')
    url
  end

  def external_id
    data['objectID']
  end

  def nsuid
    data['nsuid']
  end

  def genres
    data['genres'].to_a.compact
  end

  def developers
    data['developers'].to_a.compact
  end

  def publishers
    data['publishers'].to_a.compact
  end

  def franchises
    data['franchises'].to_a.compact
  end

  def extra
    {
      free_to_start: data['freeToStart'],
      demo_available: demo_available?,
      has_addon_content: addon_content?,
      num_of_players: data['numOfPlayers'],
      paid_subscription_required: paid_subscription_required?,
      physical_version: physical_version?,
      voucher_redeemable: voucher_redeemable?
    }.delete_if { |_, v| v.blank? && v.class != FalseClass }
  end

  def demo_available?
    data['generalFilters'].to_a.include?('Demo available')
  end

  def addon_content?
    data['generalFilters'].to_a.include?('DLC available')
  end

  def paid_subscription_required?
    data['generalFilters'].to_a.include?('Online Play via Nintendo Switch Online')
  end

  def physical_version?
    data['filterShops'].to_a.include?('At retail')
  end

  def voucher_redeemable?
    data['generalFilters'].to_a.include?('Nintendo Switch Game Voucher')
  end
end
