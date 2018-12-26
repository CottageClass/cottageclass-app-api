FactoryBot.define do
  factory :message do
    association :sender, factory: :user
    association :receiver, factory: :user
    association :cc_twilio_session, factory: :twilio_session

    content { Faker::Internet.slug }
  end
end
