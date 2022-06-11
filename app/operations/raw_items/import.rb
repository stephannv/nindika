# frozen_string_literal: true

module RawItems
  class Import < Actor
    play Fetch, Create # , Process
  end
end
