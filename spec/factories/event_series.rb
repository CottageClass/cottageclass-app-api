FactoryBot.define do
  factory :event_series do
    user
    name { Faker::FunnyName.unique.name }
    start_date { Faker::Date.unique.between 2.weeks.ago, 1.week.ago }
    starts_at { Faker::Time.unique.between 2.weeks.ago, 1.week.ago }
    ends_at { 3.hours.since starts_at }
    maximum_children { 0 }
    child_age_minimum { 0 }
    child_age_maximum { 0 }
    repeat_for { 6 }
    interval { 4 }
    activity_names { [Faker::Team.unique.sport] }
    foods { [Faker::Food.unique.dish] }
    house_rules { Faker::Lorem.unique.paragraph }
    has_pet { true }
    pet_description { Faker::Lorem.unique.paragraph }

    trait :with_event_hosts do
      transient { event_hosts_count { 2 } }

      after(:build) { |instance, evaluator| instance.event_hosts = build_list :event_host, evaluator.event_hosts_count }
    end
  end
end
