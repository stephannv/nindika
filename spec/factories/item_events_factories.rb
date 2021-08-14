# frozen_string_literal: true

FactoryBot.define do
  factory :item_event do
    item { '' }
    event_type { 'MyString' }
    title { '' }
    url { '' }
    data { '' }
  end
end
