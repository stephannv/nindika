# frozen_string_literal: true

class NintendoAlgoliaClient
  APPLICATION_ID = Rails.application.credentials.nintendo_algolia_application_id
  API_KEY = Rails.application.credentials.nintendo_algolia_api_key

  attr_reader :client

  def initialize(client: Algolia::Search::Client.create(APPLICATION_ID, API_KEY))
    @client = client
  end

  def fetch(index:, query:)
    response = index.search(query, queryType: 'prefixAll', hitsPerPage: 500, filters: 'platform:"Nintendo Switch"')
    response[:hits].to_a
  end

  def index_asc
    @index_asc ||= client.init_index('ncom_game_pt_br_title_asc')
  end

  def index_desc
    @index_desc ||= client.init_index('ncom_game_pt_br_title_des')
  end
end
