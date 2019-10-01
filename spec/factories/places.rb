FactoryBot.define do
  factory :place do
    google_id { 'unique_some_long_google_string' }
    latitude { 42.123 }
    longitude { -71.234 }
    full_address { 'some kind of string' }
    association :creator, factory: :user

    public { true }

  end
end
