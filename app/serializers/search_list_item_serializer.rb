class SearchListItemSerializer < BaseSerializer
  set_type :search_list_item

  has_one :user, serializer: PublicUserSerializer, include: %i[place]

  # this can be an event, a request or nil
  has_one :itemable, polymorphic: true, include: %i[place]
end
