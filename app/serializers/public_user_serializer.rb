class PublicUserSerializer < BaseSerializer
  set_type :user
  has_many :children, serializer: ChildSerializer
  has_one :showcase_event, record_type: :event, serializer: EventSerializer

  attributes(*User::PUBLIC_ATTRIBUTES)
  attribute :last_initial do |user|
    user.last_name[0, 1]
  end
  attribute :starred do |user, params|
    !user.received_stars.where(giver: params[:current_user]).nil?
  end
end
