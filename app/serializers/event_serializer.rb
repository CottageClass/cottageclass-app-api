class EventSerializer
  include FastJsonapi::ObjectSerializer

  has_one :user, key: :host, 
                 set_id: :host_id, 
                 serializer: PublicUserSerializer,
                 params: {current_user: current_user}
  has_many :event_hosts
  has_many :participants

  attributes(*(%i[name maximum_children child_age_minimum child_age_maximum has_pet activity_names foods house_rules
                  pet_description] + User::PUBLIC_ATTRIBUTES.map { |attribute| format('host_%s', attribute).to_sym }))
  attribute(:starts_at) { |instance| (instance.in_instance_time_zone instance.starts_at).to_s :iso8601 }
  attribute(:ends_at) { |instance| (instance.in_instance_time_zone instance.ends_at).to_s :iso8601 }
  attribute(:participants_count) { |instance| instance.participants.count }
  attribute :full, &:full?
  attribute :participated, if: proc { |_, params| params.dig(:current_user).present? } do |instance, params|
    instance.participated? params[:current_user]
  end
end
