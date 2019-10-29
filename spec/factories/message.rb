FactoryBot.define do
  factory :message do
    association :sender, factory: :user
    association :receiver, factory: :user

    content { Faker::Internet.slug }
  end
end
