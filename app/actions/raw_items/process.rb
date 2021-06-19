# frozen_string_literal: true

module RawItems
  class Process < Actor
    def call
      RawItem.pending.find_each(batch_size: 200) do |raw_item|
        process_raw_item(raw_item)
      end
    end

    private

    def process_raw_item(raw_item)
      data = ::NintendoAlgoliaDataAdapter.adapt(raw_item.data)
      item = raw_item.item || Item.new
      item.assign_attributes(data)
      item.save!
      raw_item.update!(item_id: item.id, imported: true)
    rescue StandardError => e
      raise e if Rails.env.development?

      Sentry.capture_exception(e, extra: { raw_item: raw_item.data })
    end
  end
end
