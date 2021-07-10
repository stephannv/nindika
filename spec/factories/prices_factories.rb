# frozen_string_literal: true

FactoryBot.define do
  factory :price do
    traits_for_enum :state, PriceStates.list

    association :item

    country_code { 'BR' }
    nsuid { Faker::Number.number(digits: 16).to_s }
    base_price { Money.new(Faker::Number.number(digits: 5)) }
    state { PriceStates.list.sample }
    gold_points { Faker::Number.number(digits: 2) }

    trait :with_discount do
      discount_price { Money.new(Faker::Number.number(digits: 4)) }
      discount_started_at { Faker::Date.backward(days: 30) }
      discount_ends_at { Faker::Date.forward(days: 30) }
    end
  end
end
