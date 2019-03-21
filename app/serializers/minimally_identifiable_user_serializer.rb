class MinimallyIdentifiableUserSerializer < BaseSerializer
  attributes :email,
             :first_name,
             :last_name,
             :name
end
