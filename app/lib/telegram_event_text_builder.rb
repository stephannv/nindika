# frozen_string_literal: true

class TelegramEventTextBuilder
  attr_reader :game_event, :data

  def initialize(game_event:)
    @game_event = game_event
    @data = game_event.data
  end

  def self.build(...)
    new(...).build
  end

  def build
    [
      intro,
      game_title,
      release_date,
      price,
      price_state,
      old_price,
      '',
      url
    ].compact.join("\n")
  end

  def intro
    emoji = game_event.event_type_object.emoji
    "#{emoji} <b>#{game_event.event_type_humanize}</b> #{emoji}"
  end

  def game_title
    "🕹 <b>#{game_event.title}</b>"
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
    "🔗 #{game_event.url}"
  end
end
