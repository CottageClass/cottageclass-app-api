FactoryBot.define do
  factory :star do
    starable { nil }
    giver { build :user }
  end
end
