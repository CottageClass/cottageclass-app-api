FactoryBot.define do
  factory :participant do
    association :participable, factory: :event_series
    user

    trait :event do
      association :participable, factory: :event
    end
  end
end
