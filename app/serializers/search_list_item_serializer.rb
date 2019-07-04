class SearchListItemSerializer < BaseSerializer
  set_type :search_list_item

  has_one :user, serializer: :public_user

  # this can be an event, a request or nil
  has_one :itemable, polymorphic: true
end
