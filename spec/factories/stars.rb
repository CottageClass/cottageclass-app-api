FactoryBot.define do
  factory :star do
    association :starable, factory: :user
    association :giver, factory: :user
  end
end
