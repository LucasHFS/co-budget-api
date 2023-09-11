# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :client do
      name { Faker::Name.name }
      address { Faker::Address.full_address }
      phone { Faker::PhoneNumber.cell_phone }
      gps_link { Faker::Internet.url }
      reference_point { 'reference point' }
      district { Faker::Address.community }
      role { 'client' }
    end

    trait :driver do
      name { Faker::Name.name }
      phone { Faker::PhoneNumber.cell_phone }
      role { 'driver' }
    end
  end
end
