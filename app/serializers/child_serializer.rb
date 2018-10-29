class ChildSerializer < BaseSerializer
  belongs_to :parent, record_type: :user, serializer: :user_serializer, key: :parent

  attributes :parent_id,
    :first_name,
    :birthday
end
