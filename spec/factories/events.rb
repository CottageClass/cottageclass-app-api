FactoryBot.define do
  factory :event do
    event_series
    name { Faker::Lorem.unique.sentence }
    time_zone { Faker::Address.time_zone }
    starts_at { Faker::Time.unique.between 2.weeks.since, 3.weeks.since }
    ends_at { 3.hours.since starts_at }
    maximum_children { 0 }
    child_age_minimum { 0 }
    child_age_maximum { 0 }
    house_rules { Faker::Lorem.unique.paragraph }
    has_pet { true }
    pet_description { Faker::Lorem.unique.paragraph }
  end
end
