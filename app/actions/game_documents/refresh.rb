module GameDocuments
  class Refresh < Actor
    play CreateCollection, ExportAll, UpdateAlias, RemoveOldCollections
  end
end
