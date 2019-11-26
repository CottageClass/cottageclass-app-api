class ParticipantSerializer
  include FastJsonapi::ObjectSerializer

  attributes(*User::PUBLIC_ATTRIBUTES.map { |attribute| format('user_%s', attribute).to_sym })
  attribute :event_id, &:participable_id
end
