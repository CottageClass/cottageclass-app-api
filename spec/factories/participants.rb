FactoryBot.define do
  factory :participant do
    association :participable, factory: :event
    association :user, :with_children, :with_phone_number
  end
end
