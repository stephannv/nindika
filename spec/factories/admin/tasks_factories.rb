# frozen_string_literal: true

FactoryBot.define do
  factory :admin_task, class: 'Admin::Task' do
    title { Faker::Lorem.word }
    status { Faker::Lorem.word }
    message { Faker::Lorem.word }
  end
end
