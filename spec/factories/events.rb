FactoryBot.define do
  factory :event do
    event_series
    name { Faker::FunnyName.unique.name }
    starts_at { Faker::Time.unique.between 2.weeks.since, 3.weeks.since }
    ends_at { 3.hours.since starts_at }
  end
end
