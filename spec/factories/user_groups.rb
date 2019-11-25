FactoryBot.define do
  factory :user_group do
    name { Faker::Lorem.sentence 3 }
  end
end
