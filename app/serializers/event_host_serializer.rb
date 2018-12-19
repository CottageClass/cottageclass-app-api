class EventHostSerializer
  include FastJsonapi::ObjectSerializer

  attributes :name, :email, :phone
end
