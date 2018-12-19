FactoryBot.define do
  factory :event_series do
    user { nil }
    name { 'MyString' }
    start_date { '2018-12-19' }
    starts_at { '2018-12-19 12:51:23' }
    ends_at { '2018-12-19 12:51:23' }
    repeat_for { 1 }
    interval { 1 }
    activity_names { 'MyText' }
    foods { 'MyText' }
    house_rules { 'MyText' }
    has_pet { false }
    pet_description { 'MyText' }
  end
end
