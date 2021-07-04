module GamesIndex
  class UpdateAlias < Actor
    input :client, type: Typesense::Client, default: -> { Typesense::Client.new(TypesenseConnection) }
    input :collection_name, type: String

    def call
      client.aliases.upsert('games', { 'collection_name' => collection_name })
    end
  end
end
