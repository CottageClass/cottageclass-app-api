require 'ffaker'

FactoryBot.define do
  factory :twilio_session do
    association :sender, factory: :user
    association :receiver, factory: :user

    friendly_name {FFaker::Internet.slug}
    last_action_at DateTime.now.utc
  end
end
