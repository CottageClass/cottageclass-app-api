# CottageClass App API

## Endpoints

### Users

GET `/users/:id`
- returns user with desired ID
- requires current user to have permissions for desired user
- accepts no other params
- returns: user, includes: children

POST `/users/:id`
- updates user with desired ID
- requires current user to have permissions for desired user
- accepts:
  - agree_tos
  - first_name
  - last_name
  - street_number
  - route
  - locality
  - admin_area_level_1
  - admin_area_level_2
  - country
  - postal_code
  - latitude
  - longitude
  - phone_country_code
  - phone_area_code
  - phone_number
  - available_mornings
  - available_afternoons
  - available_evenings
  - available_weekends
  - network_code
  - activities: [],
  - children: [:id, :parent_id, :first_name, :birthday]

