# frozen_string_literal: true

FactoryBot.define do
  factory :item_relationship do
    association :parent, factory: :item
    association :child, factory: :item
  end
end
