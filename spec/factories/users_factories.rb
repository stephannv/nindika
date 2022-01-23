# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    provider { Faker::Lorem.word }
    uid { Faker::Internet.uuid }
    email { Faker::Internet.email }
    name { Faker::Name.name }
    profile_image_url { Faker::Internet.url }
    admin { false }

    trait :admin do
      admin { true }
    end
  end
end
