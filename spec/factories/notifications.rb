FactoryBot.define do
  factory :notification do
    body { Faker::Lorem.sentence }
    association :recipient, factory: :user

    trait :sent do
      remote_identifier { format 'SM%s', Faker::Crypto.md5 }
    end
  end
end
