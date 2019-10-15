FactoryBot.define do
  factory :notification do
    body { Faker::Lorem.sentence }
    recipient { build :user, :with_phone_number }
    association :notifiable, factory: :event

    trait :sent do
      sms_provider_identifier { format 'SM%s', Faker::Crypto.md5 }
    end
  end
end
