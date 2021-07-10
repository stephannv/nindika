# frozen_string_literal: true

module Prices
  class Import < Actor
    play Fetch, Create
  end
end
