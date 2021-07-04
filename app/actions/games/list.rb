module Games
  class List < Actor
    input :current_user, type: User, default: nil, allow_nil: true
    input :filters, type: Hash, default: {}
    input :page, type: Integer, default: nil, allow_nil: true
    input :sort_by, type: String, default: nil, allow_nil: true

    output :games, type: OpenStruct

    def call
      games = GameExplorer.search(filters: filters, page: page, sort_by: sort_by)
      mark_wishlisted(games) if current_user.present?

      self.games = games
    end

    private

    def mark_wishlisted(games)
      game_ids = games.items.map { |item| item.document.id }

      current_user.wishlist_items.where(item_id: game_ids).each do |wishlist_item|
        item = games.items.find { |item| item.document.id == wishlist_item.item_id }
        item.document.wishlisted = true
      end
    end
  end
end
