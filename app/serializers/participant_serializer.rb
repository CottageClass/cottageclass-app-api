class ParticipantSerializer
  include FastJsonapi::ObjectSerializer

  attributes :user_id
  attribute :event_id, &:participable_id

  has_many :participant_children
end
