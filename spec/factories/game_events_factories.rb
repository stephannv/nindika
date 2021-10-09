# frozen_string_literal: true

FactoryBot.define do
  factory :game_event do
    association :game
    traits_for_enum :event_type, GameEventTypes.list
    event_type { GameEventTypes.list.sample }
    title { Faker::Lorem.word }
    url { Faker::Internet.url }
    data { Faker::Types.rb_hash(number: 4) }
  end
end
