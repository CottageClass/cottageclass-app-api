FactoryBot.define do
  factory :user_review do
    user
    association :reviewer, factory: :user
    association :reviewable, factory: :event
    body { Faker::Lorem.sentence }
    rating { Faker::Number.between 1, 5 }
  end
end
