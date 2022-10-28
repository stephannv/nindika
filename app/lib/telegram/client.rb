# frozen_string_literal: true

module Telegram
  class Client
    include HTTParty

    base_uri "https://api.telegram.org"

    def send_message(bot_token:, chat_id:, text:)
      bot = "bot#{bot_token}"
      response = self.class.post("/#{bot}/sendMessage", body: { chat_id: chat_id, text: text, parse_mode: "HTML" })
      response.parsed_response
    end
  end
end
