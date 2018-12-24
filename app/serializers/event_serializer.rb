class EventSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :maximum_children, :child_age_minimum, :child_age_maximum, :has_pet, :activity_names,
             :foods, :house_rules, :pet_description, :host_facebook_uid, :host_avatar, :host_first_name,
             :host_fuzzy_latitude, :host_fuzzy_longitude, :host_locality, :host_admin_area_level_1, :host_child_ages
  attribute(:starts_at) { |object| object.starts_at.to_s :iso8601 }
  attribute(:ends_at) { |object| object.ends_at.to_s :iso8601 }
end
