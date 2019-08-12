FactoryBot.define do
  factory :dark_star do
    association :recipient, factory: :user
    association :giver, factory: :user
  end
end
