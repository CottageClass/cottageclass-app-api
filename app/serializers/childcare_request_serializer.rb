class ChildcareRequestSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :user, serializer: PublicUserSerializer

  attribute :content
end
