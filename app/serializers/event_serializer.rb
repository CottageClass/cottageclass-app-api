class EventSerializer
  include FastJsonapi::ObjectSerializer

  has_many :participants

  attributes :name, :description, :maximum_children, :child_age_minimum, :child_age_maximum
  attribute(:starts_at) { |instance| (instance.in_instance_time_zone instance.starts_at).to_s :iso8601 }
  attribute(:ends_at) { |instance| (instance.in_instance_time_zone instance.ends_at).to_s :iso8601 }
  attribute(:participants_count) { |instance| instance.participants.count }
  attribute :full, &:full?
  attribute :participated, if: proc { |_, params| params.dig(:current_user).present? } do |instance, params|
    instance.participated? params[:current_user]
  end

  has_one :place
  has_one :user, serializer: PublicUserSerializer, include: %i[children place]
end
