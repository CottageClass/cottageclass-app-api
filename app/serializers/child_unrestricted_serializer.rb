class ChildUnrestrictedSerializer
  include FastJsonapi::ObjectSerializer

  set_type :child

  attributes :first_name, :school_name, :age_in_months
  attribute(:birthday) { |instance| instance.birthday.to_date }
end
