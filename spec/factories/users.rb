FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    name { Faker::FunnyName.unique.name }
    password { Faker::Internet.password 8, 16 }
    time_zone { Faker::Address.time_zone }
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
    referrer { Faker::Books::Lovecraft.word }
    source_tags { Faker::Books::Lovecraft.words }

    after(:build) { |instance, _| instance.skip_confirmation! if User.confirmable? }

    trait :with_matched_user do
      transient { other_user { build :user, :with_children } }
      after(:build) do |instance, evaluator|
        UserMatch.create user: instance, matched_user: evaluator.other_user
      end
    end

    trait :with_children do
      transient { children_count { 2 } }

      after(:build) { |instance, evaluator| instance.children = build_list :child, evaluator.children_count }
    end
  end
end
