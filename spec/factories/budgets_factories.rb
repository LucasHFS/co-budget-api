# frozen_string_literal: true

FactoryBot.define do
  factory :budget do
    name { Faker::Lorem.word }
  end
end
