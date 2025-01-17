class UserGivenStarsSerializer < BaseSerializer
  # this is a short term solution that doesn't allow for pagination.
  # could become a problem when some users have lots of starred items
  set_type :user

  has_many :starred_users, serializer: PublicUserSerializer,
                           params: { starred_list: true }
  has_many :starred_events, serializer: EventSerializer,
                            params: { starred_list: true }
end
