# frozen_string_literal: true

class TelegramClient
  include HTTParty

  base_uri 'https://api.telegram.org'

  def send_message(bot_token:, chat_id:, text:)
    bot = "bot#{bot_token}"
    response = self.class.post("/#{bot}/sendMessage", body: { chat_id: chat_id, text: text, parse_mode: 'HTML' })
    response.parsed_response
  end
end
