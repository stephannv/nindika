# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    external_id { Faker::Internet.unique.uuid }
    title { Faker::Game.title }
    description { Faker::Lorem.paragraph }
    website_url { Faker::Internet.url }
    nsuid { Faker::Number.number(digits: 16).to_s }
    boxart_url { Faker::Internet.url }
    banner_url { Faker::Internet.url }
    release_date { Faker::Date.between(from: 30.days.ago, to: 30.days.from_now) }
    release_date_display { release_date.to_s }
    extra { Faker::Types.rb_hash(number: 4) }
    publishers { Faker::Lorem.words(number: 2) }
    developers { Faker::Lorem.words(number: 2) }
    genres { Faker::Lorem.words(number: 3) }
    franchises { Faker::Lorem.words(number: 2) }
    on_sale { Faker::Boolean.boolean }
    new_release { Faker::Boolean.boolean }
    coming_soon { Faker::Boolean.boolean }
    pre_order { Faker::Boolean.boolean }
    all_time_visits { Faker::Number.number(digits: 3) }
    last_week_visits { Faker::Number.number(digits: 2) }

    trait :with_price do
      association :price
      current_price { price.current_price }
    end
  end
end
