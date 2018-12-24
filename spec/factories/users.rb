FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    name { Faker::ElderScrolls.unique.name }
    password { 'demo' }
    network_code { 'demo' }
    phone_number { Faker::PhoneNumber.phone_number }
    phone_area_code { Faker::PhoneNumber.area_code }
    facebook_uid { Faker::Omniauth.facebook[:uid] }
    avatar { Faker::Avatar.image Faker::Internet.slug(name, '-'), '300x300', 'png' }
    locality { Faker::Address.city }
    admin_area_level_1 { Faker::Address.state_abbr }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }

    trait :with_children do
      transient { children_count { 2 } }

      after(:build) { |instance, evaluator| instance.children = build_list :child, evaluator.children_count }
    end
  end
end
