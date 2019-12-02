FactoryBot.define do
  factory :comment do
    sender { build :user }
    group { build :user_group }
    content { Faker::Lorem.paragraph 5 }
  end
end
