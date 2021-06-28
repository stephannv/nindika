# frozen_string_literal: true

FactoryBot.define do
  factory :hidden_item do
    association :user
    association :item
  end
end
