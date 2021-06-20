# frozen_string_literal: true

FactoryBot.define do
  factory :notification do
    association :subject, factory: :item

    notification_type { NotificationTypes.list.sample }
    title { Faker::Lorem.paragraph }
    body { Faker::Lorem.paragraph }
    url { Faker::Internet.url }
    image_url { Faker::Internet.url }
    fields { Faker::Types.rb_hash(number: 4) }
  end
end
