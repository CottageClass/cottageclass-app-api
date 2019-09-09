class EventSerializer
  include FastJsonapi::ObjectSerializer

  has_many :participants

  attributes(*(%i[name maximum_children child_age_minimum child_age_maximum] + 
               User::PUBLIC_ATTRIBUTES.map { |attribute| format('host_%s', attribute).to_sym }))
  attribute(:starts_at) { |instance| (instance.in_instance_time_zone instance.starts_at).to_s :iso8601 }
  attribute(:ends_at) { |instance| (instance.in_instance_time_zone instance.ends_at).to_s :iso8601 }
  attribute(:participants_count) { |instance| instance.participants.count }
  attribute :full, &:full?
  attribute :participated, if: proc { |_, params| params.dig(:current_user).present? } do |instance, params|
    instance.participated? params[:current_user]
  end

  attribute :host do |instance, params|
    serializer = PublicUserSerializer.new instance.user,
                                          include: %i[children],
                                          params: { current_user: params[:current_user] }
    serializer.serializable_hash
  end
end
