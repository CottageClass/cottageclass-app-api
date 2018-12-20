class EventSeriesSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :start_date, :has_pet, :activity_names, :foods, :house_rules, :pet_description
  attribute(:starts_at) { |object| object.starts_at.to_s :time }
  attribute(:ends_at) { |object| object.ends_at.to_s :time }

  has_many :events
  has_many :event_hosts
end
