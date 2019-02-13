class ParticipantChildSerializer
  include FastJsonapi::ObjectSerializer

  attributes :child_id, :child_age
end
