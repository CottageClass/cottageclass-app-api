FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    name { Faker::ElderScrolls.unique.name }
    password { 'demo' }
    time_zone { Faker::Address.time_zone }
    network_code { 'demo' }
    phone_number { Faker::PhoneNumber.phone_number }
    phone_area_code { Faker::PhoneNumber.area_code }
    facebook_uid { Faker::Omniauth.facebook[:uid] }
    avatar { Faker::Avatar.image Faker::Internet.slug(name, '-'), '300x300', 'png' }
    locality { Faker::Address.city }
    admin_area_level_1 { Faker::Address.state_abbr }
    latitude { 40.730610 }
    longitude { -73.935242 }

    trait :with_children do
      transient { children_count { 2 } }

      after(:build) { |instance, evaluator| instance.children = build_list :child, evaluator.children_count }
    end
  end
end
