FactoryBot.define do
  factory :participant do
    association :participable, factory: :event
    association :user, :with_children

    trait :with_participant_children do
      transient { participant_children_count { 2 } }

      after :build do |instance, evaluator|
        instance.participant_children = build_list :participant_child, evaluator.participant_children_count,
                                                   participant: instance
      end
    end
  end
end
