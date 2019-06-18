FactoryBot.define do
  factory :user_match do
    user { nil }
    matched_user { nil }
    score { 1.5 }
  end
end
