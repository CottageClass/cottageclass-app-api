require 'ffaker'

FactoryBot.define do
  factory :twilio_session do
    friendly_name {FFaker::Internet.slug}
    last_action_at DateTime.now.utc
  end
end
