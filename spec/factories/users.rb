FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    name { Faker::FunnyName.unique.name }
    password { 'demo' }
    time_zone { Faker::Address.time_zone }
    network_code { 'demo' }
    phone_number { Faker::PhoneNumber.phone_number }
    phone_area_code { Faker::PhoneNumber.area_code }
    facebook_uid { Faker::Omniauth.facebook[:uid] }
    avatar { Faker::Avatar.image Faker::Internet.slug(name, '-'), '300x300', 'png' }
    locality { Faker::Address.city }
    admin_area_level_1 { Faker::Address.state }
    admin_area_level_2 { Faker::Address.street_name }
    apartment_number { Faker::Address.building_number }
    neighborhood { Faker::Address.street_name }
    sublocality { Faker::Address.community }
    latitude { 40.730610 }
    longitude { -73.935242 }
    images { Array.new(2).map { Faker::LoremPixel.image } }
    languages { %w[en fr de] }
    job_position { Faker::Job.title }
    employer { Faker::Company.name }
    highest_education { Faker::Demographic.educational_attainment }
    school { Faker::Educator.university }
    instagram_user { Faker::Internet.user_name }
    twitter_user { Faker::Internet.user_name }
    linkedin_user { Faker::Internet.user_name }

    trait :with_children do
      transient { children_count { 2 } }

      after(:build) { |instance, evaluator| instance.children = build_list :child, evaluator.children_count }
    end

    trait :with_user_reviews do
      transient { user_reviews_count { 2 } }

      after :build do |instance, evaluator|
        instance.user_reviews = build_list :user_review, evaluator.user_reviews_count, user: instance
      end
    end
  end
end
