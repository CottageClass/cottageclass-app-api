class ChildUnrestrictedSerializer
  include FastJsonapi::ObjectSerializer

  set_type :child

  attributes :first_name, :school_name, :age_in_months, :allergies, :dietary_restrictions, :special_needs
  attribute(:birthday) { |instance| instance.birthday.to_date }
end
