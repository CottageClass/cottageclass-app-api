class CurrentUserSerializer < BaseSerializer
  set_type :user

  has_many :children, serializer: ChildUnrestrictedSerializer
  belongs_to :place

  attributes(*User::PUBLIC_ATTRIBUTES)

  attributes :agree_tos,
             :created_at,
             :email,
             :facebook_access_token,
             :last_name,
             :phone_area_code,
             :phone_country_code,
             :phone_number,
             :phone,
             :school,
             :setting_email_notifications,
             :setting_max_distance

  attribute :date_created, &:created_at
  attribute(:hosted_events_count) { |instance, _| instance.events.past.count }
  attribute(:participated_events_count) { |instance, _| instance.participated_events.past.count }
  attribute(:upcomin_events_count) { |instance, _| instance.events.upcoming.count }

  # boolean indicating if the user has sent or recievied any messages
  attribute(:messages_active) { |instance, _| instance.sent_messages.any? || instance.received_messages.any? }
end
