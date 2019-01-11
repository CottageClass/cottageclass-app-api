class NotificationSerializer
  include FastJsonapi::ObjectSerializer

  attributes :id, :body
end
