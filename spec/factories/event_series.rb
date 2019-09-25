FactoryBot.define do
  factory :event_series do
    user
    name { Faker::Lorem.unique.sentence }
    time_zone { Faker::Address.time_zone }
    start_date { Faker::Date.unique.between 2.weeks.ago, 1.week.ago }
    starts_at { Faker::Time.unique.between 2.weeks.ago, 1.week.ago }
    ends_at { 3.hours.since starts_at }
    association :place, factory: :place
    maximum_children { 0 }
    child_age_minimum { 0 }
    child_age_maximum { 0 }
    repeat_for { 6 }
    interval { 4 }
  end
end
