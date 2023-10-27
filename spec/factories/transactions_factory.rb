# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    association :budget
    name { Faker::Lorem.word }
    price_in_cents { Faker::Number.number(digits: 4) }
    due_at { Faker::Date.between(from: 2.days.from_now, to: 30.days.from_now) }
    status { :created }
    kind { :once }
    installment_number { 1 }

    trait :late do
      due_at { Faker::Date.between(from: 30.days.ago, to: 2.days.ago) }
    end
  end
end
