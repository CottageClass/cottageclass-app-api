FactoryBot.define do
  factory :place do
    name { Faker::Lorem.sentence }
    google_id { Faker::Crypto.unique.md5 }
    apartment_number { '12a' }
    latitude { 42.123 }
    longitude { -71.234 }
    full_address { 'some kind of string' }

    public { true }

    association :creator, factory: :user
  end
end
