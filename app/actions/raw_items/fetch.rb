# frozen_string_literal: true

module RawItems
  class Fetch < Actor
    input :document_repository, type: Nintendo::DocumentRepository, default: -> { Nintendo::DocumentRepository.new }

    output :raw_items_data, type: Array

    def call
      data = terms.map { |term| document_repository.search(term) }

      self.raw_items_data = data.flatten.uniq { |d| d[:objectID] }
    end

    private

    def terms
      ('a'..'z').to_a + ('0'..'9').to_a
    end
  end
end
