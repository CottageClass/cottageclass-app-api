FactoryBot.define do
  factory :childcare_request do
    association :user, factory: :user
    content { Faker::Lorem.paragraph(5, false, 5) }
  end
end
