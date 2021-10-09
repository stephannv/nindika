# frozen_string_literal: true

FactoryBot.define do
  factory :event_dispatch do
    association :game_event

    traits_for_enum :provider, EventDispatchProviders.list
    provider { EventDispatchProviders.list.sample }
    sent_at { nil }

    trait :sent do
      sent_at { Faker::Date.between(from: 30.days.ago, to: 30.days.from_now) }
    end
  end
end
