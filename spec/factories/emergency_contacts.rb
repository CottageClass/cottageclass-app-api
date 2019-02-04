FactoryBot.define do
  factory :emergency_contact do
    association :contactable, factory: :child
    name { Faker::Name.name }
    phone_number { Faker::PhoneNumber.cell_phone }
    relationship { Faker::Lorem.word }
    allergies { Faker::Lorem.words 2 }
    dietary_restrictions { Faker::Lorem.words 2 }
    special_needs { Faker::Lorem.sentence }
  end
end
