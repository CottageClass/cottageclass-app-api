FactoryBot.define do
  factory :comment do
    sender { nil }
    group { nil }
    content { Faker::Lorem.paragraph 5 }
  end
end
