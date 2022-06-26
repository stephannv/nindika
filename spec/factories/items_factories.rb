# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    item_type { Item.item_types.keys.sample }
    external_id { Faker::Internet.unique.uuid }
    title { Faker::Game.title }
    slug { title.parameterize }
    description { Faker::Lorem.paragraph }
    website_url { Faker::Internet.url }
    nsuid { Faker::Number.number(digits: 16).to_s }
    banner_url { Faker::Internet.url }
    release_date { Faker::Date.between(from: 30.days.ago, to: 30.days.from_now) }
    release_date_display { release_date.to_s }
    publisher { Faker::Lorem.word }
    developer { Faker::Lorem.word }
    genres { Faker::Lorem.words(number: 3) }
    franchises { Faker::Lorem.words(number: 2) }
    demo_nsuid { Faker::Lorem.word }
    num_of_players { Faker::Lorem.word }
    on_sale { Faker::Boolean.boolean }
    new_release { Faker::Boolean.boolean }
    coming_soon { Faker::Boolean.boolean }
    pre_order { Faker::Boolean.boolean }
    all_time_visits { Faker::Number.number(digits: 3) }
    last_week_visits { Faker::Number.number(digits: 2) }
    languages { I18nData.languages.keys.sample(3) }
    rom_size { Faker::Number.number(digits: 10) }
    bg_color { Faker::Color.hex_color }
    headline { Faker::Lorem.paragraph }
    screenshot_urls { [Faker::Internet.url, Faker::Internet.url] }
    video_urls { Faker::Lorem.words }

    last_scraped_at { Faker::Date.between(from: 3.days.ago, to: Time.zone.today).to_time }

    trait :with_price do
      after :create do |item|
        price = create(:price, item: item)
        item.update(current_price: price.current_price)
      end
    end
  end
end
