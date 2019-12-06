FactoryBot.define do
  factory :event do
    event_series
    name { Faker::Lorem.unique.sentence }
    starts_at { Faker::Time.unique.between 2.weeks.since, 3.weeks.since }
    ends_at { 3.hours.since starts_at }
    child_age_minimum { 0 }
    child_age_maximum { 0 }

    trait :with_place do
      after(:build) do |event|
        event.place = build :place
      end
    end
  end
end
