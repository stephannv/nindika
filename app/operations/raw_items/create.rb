# frozen_string_literal: true

module RawItems
  class Create < Actor
    input :raw_items_data, type: Array

    def call
      data_size = raw_items_data.size
      index = 0

      while index < data_size
        raw_item_data = raw_items_data[index]
        create_raw_item(raw_item_data)
        index += 1
      end
    end

    private

    def create_raw_item(raw_item_data)
      raw_item = RawItem.find_or_initialize_by(external_id: raw_item_data["objectID"])
      data_checksum = Digest::MD5.hexdigest(raw_item_data.to_s)

      return if raw_item.present? && raw_item.checksum == data_checksum

      raw_item.assign_attributes(data: raw_item_data, checksum: data_checksum, imported: false)
      raw_item.save!
    rescue StandardError => e
      raise e if Rails.env.development?

      Sentry.capture_exception(e, extra: { data: raw_item_data })
    end
  end
end
