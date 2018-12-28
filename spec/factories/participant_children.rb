FactoryBot.define do
  factory :participant_child do
    participant
    participable { participant.participable }
    child { participant.user.children.sample }
  end
end
