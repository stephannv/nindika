# frozen_string_literal: true

module Nintendo
  class ItemDataAdapter
    attr_reader :data

    ATTRIBUTES = %i[
      item_type title description release_date release_date_display website_url banner_url external_id nsuid genres
      developer publisher franchises with_demo num_of_players
    ].freeze
    IMAGE_BASE_URL = "https://assets.nintendo.com/image/upload/ar_16:9,b_auto:border,c_lpad/b_white/f_auto/q_auto/dpr_auto/c_scale,w_720/v1"
    ITEM_TYPES = {
      nil => :game,
      "Individual" => :dlc,
      "Bundle" => :dlc_bundle,
      "ROM Bundle" => :game_bundle
    }.freeze

    def initialize(data)
      @data = data
    end

    def self.adapt(data)
      new(data).adapt
    end

    def adapt
      ATTRIBUTES.index_with { |attribute| send(attribute) }
    end

    private

    def item_type
      raise "NOT MAPPED ITEM TYPE: #{data['dlcType']}" unless ITEM_TYPES.key?(data["dlcType"])

      ITEM_TYPES[data["dlcType"]]
    end

    def title
      data["title"].try(:tr, "®™", "")
    end

    def description
      data["description"]
    end

    def release_date
      Date.parse("31/12/2049")
    end

    def release_date_display
      "TBD"
    end

    def website_url
      url_fixed = data["url"]&.gsub("/pt-br/", "/pt-BR/")
      "https://www.nintendo.com#{url_fixed}"
    end

    def banner_url
      "#{IMAGE_BASE_URL}/#{data['productImage']}"
    end

    def external_id
      data["objectID"]
    end

    def nsuid
      data["nsuid"]
    end

    def genres
      data["genres"].to_a.compact
    end

    def developer
      data["softwareDeveloper"]
    end

    def publisher
      data["softwarePublisher"]
    end

    def franchises
      data["franchises"].to_a.compact
    end

    def with_demo
      data["demoNsuid"].present?
    end

    def num_of_players
      data["playerCount"]
    end
  end
end
