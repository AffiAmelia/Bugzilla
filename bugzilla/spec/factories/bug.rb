# frozen_string_literal: true

FactoryBot.define do
  factory :bug do
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }
    category { 'bug' }
    status { 'pending' }
    deadline { Faker::Time.forward(days: 4) }
  end
end
