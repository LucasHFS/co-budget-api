FactoryBot.define do
  factory :delivery do
    order
    sale_event
    driver { create(:user, :driver)}

    trait :in_progress do
      state { :in_progress }
    end
    trait :completed do
      state { :completed }
    end
    trait :failed do
      state { :failed }
    end
    trait :canceled do
      state { :canceled }
    end
  end
end
