class ChildcareRequestSerializer
  include FastJsonapi::ObjectSerializer

  belongs_to :user

  attribute :content
end
