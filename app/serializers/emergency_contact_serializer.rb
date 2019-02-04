class EmergencyContactSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :phone_number, :relationship
end
