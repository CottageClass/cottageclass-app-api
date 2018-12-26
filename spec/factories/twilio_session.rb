FactoryBot.define do
  factory :twilio_session do
    association :initiator, factory: :user
    association :client, factory: :user

    friendly_name { Faker::Internet.slug }
    last_action_at { DateTime.now.utc }
  end
end
