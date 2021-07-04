module GamesIndex
  class Refresh < Actor
    play CreateCollection, InsertDocuments, UpdateAlias, RemoveOldCollections
  end
end
