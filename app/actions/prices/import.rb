# frozen_string_literal: true

module Prices
  class Import < Actor
    play Fetch, Upsert
  end
end
