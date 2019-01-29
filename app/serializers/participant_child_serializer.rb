class ParticipantChildSerializer
  include FastJsonapi::ObjectSerializer

  attributes :child_id, :child_name, :child_age
end
