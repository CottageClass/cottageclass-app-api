FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.safe_email }
    name { Faker::Name.unique.name }
    password { 'demo' }
    network_code { 'demo' }
    phone_number { Faker::PhoneNumber.phone_number }
    phone_area_code { Faker::PhoneNumber.area_code }
  end
end
