# frozen_string_literal: true

module Extensions
  module Money
    def formatted
      if cents.zero?
        I18n.t('free')
      else
        "#{symbol} #{format(symbol: false)}"
      end
    end
  end
end
