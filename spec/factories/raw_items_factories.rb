# frozen_string_literal: true

FactoryBot.define do
  factory :raw_item do
    external_id { Faker::Internet.unique.uuid }
    data { Faker::Types.rb_hash(number: 4) }
    checksum { Digest::MD5.hexdigest(data.to_s) }
    imported { Faker::Boolean.boolean }

    trait :with_item do
      association :item
    end
  end
end
