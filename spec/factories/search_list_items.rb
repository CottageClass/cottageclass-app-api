FactoryBot.define do
  factory :search_list_item do
    association :user, :with_children
    trait :with_event do
      association :itemable, factory: :event
    end
  end
end
