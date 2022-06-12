# frozen_string_literal: true

module Items
  class ScrapPendingItemsData < Actor
    def call
      Item.pending_scrap.find_each(batch_size: 200) do |item|
        Items::ScrapData.call(item: item)
      rescue StandardError => e
        raise e if Rails.env.development?

        item.update(last_scraped_at: Time.zone.now)
        Sentry.capture_exception(e, extra: { item_id: item.id })
      end
    end
  end
end
