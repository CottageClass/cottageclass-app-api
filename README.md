# CottageClass App API

## Endpoints

### Users

GET `/networks/:network_code/users`
- returns array of all users with desired networkCode
- requires current user to belong to desired networkCode
- accepts no other params
- returns: list of users, with subset of params (first, last, lat, long, address, phone, availability, activities)

GET `/users/:id/inquiries`
- requires current user
- accepts no params
- returns: list of all users *in user's current network* who have messaged the current user

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
- returns: updated user, includes: children

### Proxy Sessions

POST `/users/:id/proxy_sessions`
- finds a live session or creates a new proxy session for current_user and User.find(:id)
- accepts:
  - request_message
  - acknowledgement_message

### Auth

POST `/auth/user_token`
- fetches a new user auth token
- currently not used

POST `/auth/facebook`
- exchanges an OAuth 2 authorization code (obtained via popup on frontend) for a user auth token
- used by VueAuthenticate and Facebook Login
