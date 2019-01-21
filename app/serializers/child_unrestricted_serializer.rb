class ChildUnrestrictedSerializer
  include FastJsonapi::ObjectSerializer

  set_type :child

  attributes :first_name, :school_name, :age, :emergency_contact_name, :emergency_contact_phone_number,
             :emergency_contact_relationship, :allergies, :dietary_restrictions, :special_needs
  attribute(:birthday) { |instance| instance.birthday.to_date }
end
