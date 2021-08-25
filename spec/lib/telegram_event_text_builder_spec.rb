# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TelegramEventTextBuilder, type: :lib do
  describe '.build' do
    let(:item_event) do
      event_data = {
        release_date: Faker::Lorem.word,
        current_price: Faker::Lorem.word,
        discount_percentage: Faker::Lorem.word,
        base_price: Faker::Lorem.word,
        price_state: Faker::Lorem.word,
        old_price: Faker::Lorem.word,
        state: Faker::Lorem.word
      }
      create(:item_event, data: event_data)
    end
    let(:data) { item_event.data }

    it 'builds telegram text using item event data' do
      emoji = item_event.event_type_object.emoji
      expected_response = <<~HEREDOC
        #{emoji} <b>#{item_event.event_type_humanize}</b> #{emoji}
        🕹 <b>#{item_event.title}</b>
        📆 #{data['release_date']}
        💵 #{data['current_price']} <s>#{data['base_price']}</s> (#{data['discount_percentage']})
        📢 #{data['state']}
        ❌ #{data['old_price']}

        🔗 #{item_event.url}
      HEREDOC

      expect(described_class.build(item_event: item_event)).to eq expected_response.chop
    end

    context 'when non-required data is blank' do
      let(:item_event) { create(:item_event) }

      it 'builds telegram text with required data only' do
        emoji = item_event.event_type_object.emoji
        expected_response = <<~HEREDOC
          #{emoji} <b>#{item_event.event_type_humanize}</b> #{emoji}
          🕹 <b>#{item_event.title}</b>

          🔗 #{item_event.url}
        HEREDOC

        expect(described_class.build(item_event: item_event)).to eq expected_response.chop
      end
    end
  end
end
