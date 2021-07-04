module GamesIndex
  class CreateCollection < Actor
    input :client, type: Typesense::Client, default: -> { Typesense::Client.new(TypesenseConnection) }

    output :collection_name, type: String

    def call
      self.collection_name = "games_#{Time.zone.now.to_s(:number)}"

      schema = GameIndexSerializer::SCHEMA.merge(name: collection_name)
      client.collections.create(schema)
    end
  end
end
