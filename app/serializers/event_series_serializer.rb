class EventSeriesSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :start_date, :maximum_children, :child_age_minimum, :child_age_maximum
  attribute(:starts_at) { |object| object.starts_at.to_s :time }
  attribute(:ends_at) { |object| object.ends_at.to_s :time }

  has_many :events
end
