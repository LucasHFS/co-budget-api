FactoryBot.define do
  factory :line_item, class: "LineItem" do
    quantity { rand(1..3) }

    product
    order
  end
end
