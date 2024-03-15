# frozen_string_literal: true

FactoryBot.define do
  factory :collection do
    kind { 1 }

    trait :with_transactions do
      after(:create) do |collection|
        create_list(:transaction, 3, collection:)
      end
    end
  end
end
