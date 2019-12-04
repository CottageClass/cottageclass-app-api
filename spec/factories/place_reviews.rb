FactoryBot.define do
  factory :place_review do
    place { nil }
    user { nil }
    stars { "" }
    content { "MyText" }
  end
end
