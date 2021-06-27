# frozen_string_literal: true

FactoryBot.define do
  factory :wishlist_item do
    association :user
    association :item
  end
end
