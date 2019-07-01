class SearchListItemSerializer < BaseSerializer
  set_type :search_list_item

  has_one :user, serializer: :user_serializer
  # this can be an event, a request or nil
  has_one :itemable, polymorphic: true
end
