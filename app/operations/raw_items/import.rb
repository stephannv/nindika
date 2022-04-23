# frozen_string_literal: true

module RawItems
  class Import < Actor
    play FetchAll, Create, Process
  end
end
