FactoryBot.define do
  factory :order do
    name { 'a' }
    notes { 'order notes' }
    is_delivery { true }
    state { :pending }

    client { create(:user, :client) }
    sale_event

    trait :prepared do
      state { :prepared }
    end

    trait :sent do
      state { :sent }
    end

    trait :completed do
      state { :completed }
    end

    trait :canceled do
      state { :canceled }
    end

    after(:create) do |order|
      create_list(:line_item, 2, order:)
    end
  end
end
