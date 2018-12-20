class EventSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name
  attribute(:starts_at) { |object| object.starts_at.to_s :iso8601 }
  attribute(:ends_at) { |object| object.ends_at.to_s :iso8601 }
end
