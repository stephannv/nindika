# frozen_string_literal: true

module Nintendo
  class RequestsBuilder
    TOKENS = (("a".."z").to_a + ("0".."9").to_a).freeze
    INDEXES = %w[
      store_game_pt_br
      store_game_pt_br_release_des
      store_game_pt_br_title_asc
      store_game_pt_br_title_des
      store_game_pt_br_price_asc
      store_game_pt_br_price_des
    ].freeze
    ITEMS_PER_PAGE = 1000
    MAX_PAGES = 1

    def self.build
      new.build
    end

    def build
      requests = []

      INDEXES.each do |index|
        TOKENS.each do |token|
          (0...MAX_PAGES).each do |page|
            requests << build_request(index: index, token: token, page: page)
          end
        end
      end

      requests
    end

    private

    def build_request(index:, token:, page:)
      {
        indexName: index,
        query: token,
        page: page,
        hitsPerPage: ITEMS_PER_PAGE,
        facetFilters: ["corePlatforms:Nintendo Switch"]
      }
    end
  end
end
