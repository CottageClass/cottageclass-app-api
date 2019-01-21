FactoryBot.define do
  factory :child do
    first_name { Faker::Name.unique.first_name }
    birthday { Faker::Date.unique.between 6.years.ago, 2.years.ago }
    school_name { Faker::Educator.unique.secondary_school }
    emergency_contact_name { Faker::Name.name }
    emergency_contact_phone_number { Faker::PhoneNumber.cell_phone }
    emergency_contact_relationship { Faker::Lorem.word }
    allergies { Faker::Lorem.words 2 }
    dietary_restrictions { Faker::Lorem.words 2 }
    special_needs { Faker::Lorem.sentence }
  end
end
