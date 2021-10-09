# frozen_string_literal: true

FactoryBot.define do
  factory :wishlist_game do
    association :user
    association :game
  end
end
