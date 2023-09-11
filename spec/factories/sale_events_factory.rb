# frozen_string_literal: true

FactoryBot.define do
  factory :sale_event do
    date { Time.current }
    name { Faker::Lorem.word }
  end
end
