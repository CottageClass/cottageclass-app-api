require 'ffaker'

FactoryBot.define do
  factory :user do
    email { FFaker::Internet.email }
    name { FFaker::Name.name }
    password { 'demo' }
    network_code { 'demo' }
    phone_number { FFaker::PhoneNumber.phone_number }
    phone_area_code { FFaker::PhoneNumber.area_code }
  end
end
