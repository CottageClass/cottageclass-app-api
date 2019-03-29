class CurrentUserSerializer < BaseSerializer
  set_type :user

  has_many :children, serializer: ChildUnrestrictedSerializer

  attributes(*User::PUBLIC_ATTRIBUTES)

  attributes :agree_tos,
             :apartment_number,
             :created_at,
             :facebook_access_token,
             :full_address,
             :last_name,
             :latitude,
             :longitude,:route,
             :phone_area_code,
             :phone_country_code,
             :phone_number,
             :phone,
             :postal_code,
             :school,
             :street_number

  attribute :date_created, &:created_at
  attribute(:hosted_events_count) { |instance, _| instance.events.past.count }
  attribute(:participated_events_count) { |instance, _| instance.participated_events.past.count }
end
