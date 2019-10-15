FactoryBot.define do
  factory :participant do
    association :participable, factory: :event
    association :user, :with_children, :with_phone_number

    trait :with_participant_children do
      after :build do |instance, _|
        instance.user.children.each do |child|
          instance.participant_children << build(:participant_child, participant: instance, child: child)
        end
      end
    end
  end
end
