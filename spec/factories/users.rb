FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    name { Faker::FunnyName.unique.name }
    password { Faker::Internet.password 8, 16 }
    phone_number { Faker::PhoneNumber.phone_number }
    phone_area_code { Faker::PhoneNumber.area_code }
    facebook_uid { Faker::Omniauth.facebook[:uid] }
    avatar { Faker::Avatar.image Faker::Internet.slug(name, '-'), '300x300', 'png' }
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

    trait :with_place do
      after(:build) do |user|
        user.place = build :place, creator: user
      end
    end

    trait :with_matched_user do
      transient { other_user { build :user, :with_children, :with_place } }
      after(:build) do |instance, evaluator|
        UserMatch.create user: instance, matched_user: evaluator.other_user
      end
    end

    trait :with_children do
      transient { children_count { 2 } }
      after(:build) do |instance, evaluator|
        instance.children = build_list :child, evaluator.children_count
      end
    end
  end
end
