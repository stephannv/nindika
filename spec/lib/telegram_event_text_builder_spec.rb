# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramEventTextBuilder, type: :lib do
  describe '.build' do
    let(:game_event) do
      event_data = {
        release_date: Faker::Lorem.word,
        current_price: Faker::Lorem.word,
        discount_percentage: Faker::Lorem.word,
        base_price: Faker::Lorem.word,
        price_state: Faker::Lorem.word,
        old_price: Faker::Lorem.word,
        state: Faker::Lorem.word
      }
      create(:game_event, data: event_data)
    end
    let(:data) { game_event.data }

    it 'builds telegram text using game event data' do
      emoji = game_event.event_type_object.emoji
      expected_response = <<~HEREDOC
        #{emoji} <b>#{game_event.event_type_humanize}</b> #{emoji}
        🕹 <b>#{game_event.title}</b>
        📆 #{data['release_date']}
        💵 #{data['current_price']} <s>#{data['base_price']}</s> (#{data['discount_percentage']})
        📢 #{data['state']}
        ❌ #{data['old_price']}

        🔗 #{game_event.url}
      HEREDOC

      expect(described_class.build(game_event: game_event)).to eq expected_response.chop
    end

    context 'when non-required data is blank' do
      let(:game_event) { create(:game_event) }

      it 'builds telegram text with required data only' do
        emoji = game_event.event_type_object.emoji
        expected_response = <<~HEREDOC
          #{emoji} <b>#{game_event.event_type_humanize}</b> #{emoji}
          🕹 <b>#{game_event.title}</b>

          🔗 #{game_event.url}
        HEREDOC

        expect(described_class.build(game_event: game_event)).to eq expected_response.chop
      end
    end
  end
end
