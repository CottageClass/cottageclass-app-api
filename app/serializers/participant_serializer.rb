class ParticipantSerializer
  include FastJsonapi::ObjectSerializer

  attributes :user_id, :user_facebook_uid, :user_avatar, :user_first_name, :user_fuzzy_latitude, :user_fuzzy_longitude,
             :user_locality, :user_sublocality, :user_neighborhood, :user_admin_area_level_1, :user_admin_area_level_2,
             :user_verified
  attribute :event_id, &:participable_id

  has_many :participant_children
end
