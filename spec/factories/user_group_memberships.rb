FactoryBot.define do
  factory :user_group_membership do
    user { build :user }
    user_group { build :user_group }
  end
end
