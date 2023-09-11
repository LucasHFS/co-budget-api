FactoryBot.define do
  factory :product do
    name { Faker::Commerce.product_name }
    price_in_cents { rand(99..50_00) }
  end
end
