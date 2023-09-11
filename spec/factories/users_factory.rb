# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    full_name { Faker::Name.name }
    avatar_url { 'http://www.gravatar.com/avatar/?d=mp' }
  end
end
