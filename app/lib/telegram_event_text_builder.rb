# frozen_string_literal: true

class TelegramEventTextBuilder
  attr_reader :item_event, :data

  def initialize(item_event:)
    @item_event = item_event
    @data = item_event.data
  end

  def self.build(...)
    new(...).build
  end

  def build
    [
      intro,
      item_title,
      release_date,
      price,
      price_state,
      old_price,
      '',
      url
    ].compact.join("\n")
  end

  def intro
    emoji = item_event.event_type_object.emoji
    "#{emoji} <b>#{item_event.event_type_humanize}</b> #{emoji}"
  end

  def item_title
    "🕹 <b>#{sanitize_string(item_event.title)}</b>"
  end

  def release_date
    "📆 #{data['release_date']}" if data['release_date'].present?
  end

  def price
    return if data['current_price'].blank?

    ['💵', data['current_price'], base_price, discount_percentage].compact.join(' ')
  end

  def discount_percentage
    "(#{data['discount_percentage']})" if data['discount_percentage'].present?
  end

  def base_price
    "<s>#{data['base_price']}</s>" if data['base_price'].present?
  end

  def price_state
    "📢 #{data['state']}" if data['state'].present?
  end

  def old_price
    "❌ #{data['old_price']}" if data['old_price'].present?
  end

  def url
    "🔗 #{item_event.url}"
  end

  def sanitize_string(string)
    string
      .gsub('&', '&amp;')
      .gsub('<', '&lt;')
      .gsub('>', '&gt;')
  end
end
