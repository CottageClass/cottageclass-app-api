FactoryBot.define do
  factory :event do
    event_series
    name { Faker::FunnyName.unique.name }
    starts_at { Faker::Time.unique.between 2.weeks.since, 3.weeks.since }
    ends_at { 3.hours.since starts_at }
    maximum_children { 0 }
    child_age_minimum { 0 }
    child_age_maximum { 0 }
    activity_names { [Faker::Team.unique.sport] }
    foods { [Faker::Food.unique.dish] }
    house_rules { Faker::Lorem.unique.paragraph }
    has_pet { true }
    pet_description { Faker::Lorem.unique.paragraph }
  end
end
