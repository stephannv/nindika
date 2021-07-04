module GameDocuments
  class RemoveOldCollections < Actor
    input :client, type: Typesense::Client, default: -> { Typesense::Client.new(TypesenseConnection) }
    input :collection_name, type: String

    def call
      collections = client.collections.retrieve

      old_collections = collections.reject { |d| ['games', collection_name].include?(d['name']) }

      old_collections.each do |collection|
        client.collections[collection['name']].delete
      end
    end
  end
end
