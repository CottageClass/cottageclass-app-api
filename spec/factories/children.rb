FactoryBot.define do
  factory :child do
    first_name { Faker::Name.unique.first_name }
    birthday { Faker::Date.unique.between 6.years.ago, 2.years.ago }
    school_name { Faker::Educator.unique.secondary_school }
  end
end
