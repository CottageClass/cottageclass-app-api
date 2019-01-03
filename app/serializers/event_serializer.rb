class EventSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :maximum_children, :child_age_minimum, :child_age_maximum, :has_pet, :activity_names,
             :foods, :house_rules, :pet_description, :host_facebook_uid, :host_avatar, :host_first_name,
             :host_fuzzy_latitude, :host_fuzzy_longitude, :host_locality, :host_admin_area_level_1, :host_child_ages
  attribute(:starts_at) { |instance| instance.with_instance_time_zone { instance.starts_at.to_s :iso8601 } }
  attribute(:ends_at) { |instance| instance.with_instance_time_zone { instance.ends_at.to_s :iso8601 } }
  attribute(:participants_count) { |instance| instance.participants.count }
  attribute :full, &:full?
  attribute :participated, if: proc { |_, params| params.dig(:current_user).present? } do |instance, params|
    instance.participated? params[:current_user]
  end

  has_many :event_hosts
end
