# frozen_string_literal: true

class ItemTypes < EnumerateIt::Base
  associate_values :game, :game_bundle, :dlc, :dlc_bundle
end
