class ParticipantSerializer
  include FastJsonapi::ObjectSerializer

  has_many :participant_children

  attributes(*User::PUBLIC_ATTRIBUTES.map { |attribute| format('user_%s', attribute).to_sym })
  attribute :event_id, &:participable_id
end
