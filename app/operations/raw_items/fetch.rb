# frozen_string_literal: true

module RawItems
  class Fetch < Actor
    input :client, type: Nintendo::Client, default: -> { Nintendo::Client.new }

    output :raw_items_data, type: Array

    def call
      items_hash = {}

      client.list_items_in_batches do |response|
        response["results"].each do |result|
          result["hits"].each do |hit|
            items_hash[hit["objectID"]] = hit.except!("createdAt", "updatedAt")
          end
        end
      end

      self.raw_items_data = items_hash.values
    end
  end
end
