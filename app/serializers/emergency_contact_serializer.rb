class EmergencyContactSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :phone_number, :relationship, :special_needs, :allergies, :dietary_restrictions
end
