FactoryBot.define do
  factory :emergency_contact do
    association :contactable, factory: :child
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.cell_phone }
    relationship { Faker::Lorem.word }
  end
end
