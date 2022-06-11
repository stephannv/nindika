# frozen_string_literal: true

module Extensions
  module Money
    def formatted(integer: false)
      if cents.zero?
        I18n.t("free")
      else
        number_display = integer ? to_i : format(symbol: false)
        "#{symbol} #{number_display}"
      end
    end
  end
end
