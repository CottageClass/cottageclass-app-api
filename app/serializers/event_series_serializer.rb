class EventSeriesSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name, :start_date, :starts_at, :ends_at, :repeat_for, :interval, :has_pet, :activity_names, :foods, :house_rules, :pet_description
end
