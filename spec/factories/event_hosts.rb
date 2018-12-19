FactoryBot.define do
  factory :event_host do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.free_email }
    phone { Faker::PhoneNumber.unique.cell_phone }
  end
end
