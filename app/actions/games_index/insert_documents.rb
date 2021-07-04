module GamesIndex
  class InsertDocuments < Actor
    input :client, type: Typesense::Client, default: -> { Typesense::Client.new(TypesenseConnection) }
    input :collection_name, type: String

    def call
      documents = Item.joins(:price).includes(:price).order(:title).map.with_index do |item, index|
        GameIndexSerializer.new(item).serializable_hash.compact.stringify_keys.merge('title_order' => index)
      end

      documents.in_groups_of(100, false) do |group|
        client.collections[collection_name].documents.import(group, action: 'create', batch_size: 100)
      end
    end
  end
end
