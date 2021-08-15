# frozen_string_literal: true

FactoryBot.define do
  factory :item_event do
    association :item
    traits_for_enum :event_type, ItemEventTypes.list
    event_type { ItemEventTypes.list.sample }
    title { Faker::Lorem.word }
    url { Faker::Internet.url }
    data { Faker::Types.rb_hash(number: 4) }
  end
end
