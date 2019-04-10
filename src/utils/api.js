import camelcaseKeys from 'camelcase-keys'
import normalize from 'json-api-normalizer'
import axios from 'axios'
import { createEvent, createEvents } from './createEvent'
import { createUser } from './createUser'

export function initProxySession (currentUserId, receiverId, requestMessage, acknowledgmentMessage) {
  console.log('INITIATING PROXY WITH users ' + currentUserId + ', ' + receiverId)
  let postData = {
    twilioSession: {
      requestMessage: requestMessage,
      acknowledgmentMessage: acknowledgmentMessage
    }
  }
  return axios.post(
    `/users/${receiverId}/proxy_sessions`,
    postData
  ).then(res => {
    console.log('proxy session init SUCCESS, returning proxy phone number for receiver')
    // return proxy number for receiver
    return res.data.data.attributes.proxyIdentifierReceiver
  }).catch(err => {
    console.log('proxy session init FAILURE')
    console.log(err)
    throw err
  })
}

/*
 * USERS
 */

export function submitUserInfo (userId, data) {
  if (!data) { return }

  let { phone, location, availability, images } = data

  let postData = {}
  if (location && location.fullAddress) {
    let address = location.fullAddress
    let {
      street_number,
      route,
      locality,
      administrative_area_level_1,
      administrative_area_level_2,
      sublocality,
      neighborhood,
      country,
      postal_code
    } = address

    postData = {
      streetNumber: street_number,
      route: route,
      locality: locality,
      // snake_case key name is ugly but necessary for backend to recognize attr with trailing 1
      admin_area_level_1: administrative_area_level_1,
      admin_area_level_2: administrative_area_level_2,
      sublocality,
      neighborhood,
      country: country,
      postalCode: postal_code,
      latitude: location.lat,
      longitude: location.lng
    }
  }

  if (location && location.apartmentNumber) {
    postData = {
      ...postData,
      apartmentNumber: location.apartmentNumber
    }
  }

  if (phone && phone.number) {
    let phoneAreaCode = phone.number.match(/(\(\d+\))/)[0].replace(/[^\d]/g, '')
    let phoneNumber = phone.number.match(/\d{3}-\d{4}/)[0].replace(/[^\d]/g, '')
    postData = {
      ...postData,
      phoneAreaCode: phoneAreaCode,
      phoneNumber: phoneNumber
    }
  }

  // set child attributes, plus the parentId
  if (data.children && data.children.length > 0) {
    postData.childrenAttributes = data.children.map(function (childAttrs) {
      return {
        ...childAttrs,
        parentId: userId
      }
    })
  }

  if (data.availability) {
    postData = {
      ...postData,
      ...availability
    }
  }

  if (data.employer) {
    postData.employer = data.employer
  }

  if (data.jobPosition) {
    postData.jobPosition = data.jobPosition
  }

  if (data.profileBlurb) {
    postData.profileBlurb = data.profileBlurb
  }

  if (images) {
    postData.images = data.images
  }

  if (data.activities) {
    postData.activities = data.activities
  }

  if (data.languages) {
    postData.languages = data.languages
  }

  return axios.post(
    `/users/${userId}`,
    postData
  ).then(res => {
    console.log('SUBMIT USER SUCCESS', res)
    return res
  }).catch(err => {
    console.log('SUBMIT USER FAILURE', err)
    throw err
  })
}

function createPersonObject (personInApi, availableChildren = []) {
  var p = personInApi.attributes
  let hasAllRequiredFields = function () {
    if (p.phone && p.latitude && p.longitude) {
      return true
    } else {
      return false
    }
  }
  let createChildrenList = function () {
    let parseChild = function (child) {
      return {
        age: child.attributes.age
      }
    }
    return availableChildren.filter(child => child.attributes.parent_id === personInApi.id).map(parseChild)
    // make sure this is an array.
  }

  let activities = p.activities || []
  activities = activities.map(activity => activity.replace(/_/g, ' '))

  return {
    agreeTos: p.agree_tos,
    id: personInApi.id,
    childAges: p.child_ages,
    firstName: p.first_name,
    avatar: p.avatar,
    activities: activities,
    availableMornings: p.available_mornings,
    availableEvenings: p.available_evenings,
    availableAfternoons: p.available_afternoons,
    availableWeekends: p.available_weekends,
    lastInitial: capitalize(p.last_initial),
    location: {
      lat: parseFloat(p.fuzzy_latitude),
      lng: parseFloat(p.fuzzy_longitude)
    },
    // todo: add these once API has them
    title: '',
    employer: '',
    backgroundCheck: false,
    facebookUid: p.facebook_uid,
    facebookMapIcon: 'https://graph.facebook.com/' + p.facebook_uid + '/picture?width=30',
    // todo: add children now somehow
    children: createChildrenList(),
    // todo: add these once I have them
    verified: p.verified,
    phone: p.phone,
    dateCreated: p.date_created,
    hasAllRequiredFields: hasAllRequiredFields(),
    blurb: p.profile_blurb
  }
}

// parses responseData into peopleArray and childrenArray
function createPeopleObject (responseData) {
  let peopleDataArray = responseData.data
  let included = responseData.included || []
  let childrenArray = included.filter(obj => obj.type === 'child')
  return peopleDataArray.map(personInApi => createPersonObject(personInApi, childrenArray))
}

export function fetchUsersWithinDistance ({ miles, lat, lng, pageSize = 100, page = 1 }) {
  return axios.get(
    `/api/users/miles/${miles}/latitude/${lat}/longitude/${lng}/page/${page}/page_size/${pageSize}`
  ).then(res => {
    console.log('FETCH USERS WITHIN DISTANCE SUCCESS')
    console.log(res.data)
    return createPeopleObject(res.data)
  }).catch(err => {
    console.log('FETCH USERS WITHIN DISTANCE FAILURE')
    console.log(err)
    throw err
  })
}

export function fetchUsers () {
  return axios.get(
    `/api/users`
  ).then(res => {
    console.log('FETCH USERS IN NETWORK SUCCESS')
    console.log(res.data)
    return createPeopleObject(res.data)
  }).catch(err => {
    console.log('FETCH USERS IN NETWORK FAILURE')
    console.log(err.errors)
    throw err
  })
}

export function fetchUsersWhoHaveMadeInquiries (currentUserId) {
  return axios.get(
    `/users/${currentUserId}/inquiries`
  ).then(res => {
    console.log('FETCH USERS WHO HAVE MADE INQUIRIES SUCCESS')
    console.log(res.data)
    return createPeopleObject(res.data)
  }).catch(err => {
    console.log('FETCH USERS WHO HAVE MADE INQUIRIES FAILURE')
    console.log(err.errors)
    throw err
  })
}

// Public
export async function fetchUser (userId) {
  try {
    const res = await axios.get(`/api/users/${userId}`)
    console.log('FETCH PUBLIC USER #' + userId + ' SUCCESS')
    return createUser(normalize(res.data))
  } catch (err) {
    console.log('FETCH PUBLIC USER #' + userId + ' FAILURE')
    console.log(err.errors)
    throw err
  }
}

// Private
export async function fetchCurrentUser (userId) {
  try {
    const res = await axios.get(`/api/users/${userId}`)
    console.log('FETCH PRIVATE USER #' + userId + ' SUCCESS')
    console.log(res)
    return createUser(normalize(res.data))
  } catch (err) {
    console.log('FETCH PRIVATE USER #' + userId + ' FAILURE')
    console.log(err.errors)
    throw err
  }
}

export async function fetchFacebookImages (facebookAccessToken) {
  try {
    const res = await axios.get(`https://graph.facebook.com/me/photos?fields=images&access_token=${facebookAccessToken}`)
    return res.data.data
  } catch (e) {
    console.log(e)
    return null
  }
}

/*
 * CHILDREN
 */

export function submitEmergencyContacts (childId, arrayOfContacts) {
  return axios.put(
    `/api/user/children/${childId}`,
    {
      child:
      {
        'emergency_contacts_attributes': arrayOfContacts
      }
    }).then(res => {
    console.log('SUBMIT EMERGENCY CONTACTS SUCCESS', res)
  }).catch(err => {
    console.log('SUBMIT EMERGENCY CONTACTS FAILURE', childId, arrayOfContacts)
    throw err
  })
}

// backend requires user to be an admin
export function fetchAllUsers () {
  return axios.get(
    `/users`
  ).then(res => {
    console.log('FETCH ALL USERS SUCCESS')
    console.log(createPeopleObject(res.data))
    return createPeopleObject(res.data)
  }).catch(err => {
    console.log('FETCH ALL USERS FAILURE')
    console.log(err.errors)
    throw err
  })
}

/*
 * MESSAGES
 */

function createMessagesObject (msgListFromApi) {
  return msgListFromApi.map(createMessageObject)
}

function createMessageObject (msgFromApi) {
  return {
    id: msgFromApi.id,
    ...camelcaseKeys(msgFromApi.attributes, { deep: true })
  }
}

export function fetchMessagesForUserPair (participantId1, participantId2) {
  return axios.get(
    `/users/${participantId1}/messages/${participantId2}`
  ).then(res => {
    console.log('FETCH Messages for User Pair SUCCESS')
    console.log(createMessagesObject(res.data.data))
    return createMessagesObject(res.data.data)
  }).catch(err => {
    console.log('FETCH Messages for User Pair FAILURE')
    console.log(err)
    console.log(err.errors)
    throw err
  })
}

/*
 * NOTIFICATIONS
 */

export function submitNotification (participantId, notificationBodyText) {
  let notificationData = {
    'notification': {
      'body': notificationBodyText
    }
  }
  return axios.post(
    `/api/users/${participantId}/notifications/`, notificationData
  ).then(res => {
    console.log('NOTIFICATION submission SUCCESS')
    return res
  }).catch(err => {
    console.log('NOTIFICATION submission FAILURE')
    console.log(err)
    throw err
  })
}

/*
 * EVENTS
 */

export const fetchUpcomingEvents = async (userId, sortBy) => {
  return axios.get(
    `/api/users/${userId}/events/created/upcoming/page/1/page_size/100`
  ).then(res => {
    console.log('FETCH MY UPCOMING EVENTS SUCCESS')
    return createEvents(normalize(res.data), sortBy)
  }).catch(err => {
    console.log('FETCH MY UPCOMING EVENTS FAILURE')
    console.log(err.errors)
    throw err
  })
}

export function submitEventSeriesData (data) {
  return axios.post(
    `/api/event_series`, data
  ).then(res => {
    return Object.values(normalize(res.data).event).map(parseEventData)
  })
}

export const fetchEvents = async (params, sortBy) => {
  const url = `/api/events/${params || ''}`
  return axios.get(url).then(res => {
    console.log('FETCH SUCCESS -- ', url)
    // console.log(res.data)
    return createEvents(normalize(res.data), sortBy)
  }).catch(err => {
    console.log('FETCH FAILURE -- ', url)
    console.log(err.errors)
    throw err
  })
}

export const fetchEvent = async (id) => {
  id = id.toString()
  try {
    const res = await axios.get(`/api/events/${id}`)
    if (res) {
      return createEvent(normalize(res.data))
    } else {
      throw Error('failed to fetch event')
    }
  } catch (e) {
    throw e
  }
}

export function fetchUpcomingEventsWithinDistance ({ miles, lat, lng, pageSize = 100, page = 1 }) {
  return fetchEvents(
    `upcoming/miles/${miles}/latitude/${lat}/longitude/${lng}/page/${page}/page_size/${pageSize}`,
    e => e.startsAt
  )
}

export function fetchUpcomingParticipatingEvents (userId) {
  return axios.get(`/api/users/${userId}/events/participated/upcoming/page/1/page_size/100`)
    .then(res => {
      console.log('GET PARTICIPATING EVENTS SUCCESS')
      console.log(res)
      const normedData = normalize(res.data)
      if (!normedData.event) {
        return []
      }
      return Object.values(normedData.event).map(parseEventData)
    }).catch(err => {
      console.log('GET PARTICIPATING EVENTS FAILURE')
      console.log(err)
      console.log(Object.entries(err))
      throw err
    })
}

export function removeEventParticipant (eventId) {
  return axios.delete(`/api/events/${eventId}/participants`)
    .then(res => {
      console.log('REMOVE EVENT PARTICIPANT SUCCESS')
      console.log(res)
      return res
    })
    .catch(err => {
      console.log('REMOVE EVENT PARTICIPANT FAILURE')
      console.log(err)
      console.log(Object.entries(err))
      throw err
    })
}

export function submitEventParticipant (eventId, participantChildIds) {
  let createChild = function (childId) {
    return {
      'child_id': childId
    }
  }
  let participantData = {
    'participant': {
      'participant_children_attributes': participantChildIds.map(createChild)
    }
  }
  return axios.post(`/api/events/${eventId}/participants`, participantData)
    .then(res => {
      console.log('SUBMIT EVENT PARTICIPANT SUCCESS')
      console.log(res)
      return res
    })
    .catch(err => {
      console.log('SUBMIT EVENT PARTICIPANT FAILURE')
      console.log(err)
      console.log(Object.entries(err))
      throw err
    })
}

export function deleteEvent (eventId, successCallback) {
  return axios.delete(`/api/events/${eventId}`)
    .then(res => {
      console.log('DELETE EVENT SUCCESS')
      console.log(res)
      successCallback()
    })
    .catch(err => {
      console.log('DELETE EVENT FAILURE')
      console.log(err)
      console.log(Object.entries(err))
      throw err
    })
}

/**********
 *  Authentication
 **********/

// sign up as a new user
export function register (params) {
  return axios.post(`/users`, params)
}

export function signIn (params) {
  return axios.post(`/users/sign_in`, { user: params })
}

// destroy the current session on the server
export function signOut () {
  return axios.delete(`/users/sign_out`)
}

/*
 * UTILS
 */

// TODO get this out of here
export function distanceHaversine (lat1, lon1, lat2, lon2) {
  const unit = 'N' // always return miles
  var radlat1 = Math.PI * lat1 / 180
  var radlat2 = Math.PI * lat2 / 180
  var theta = lon1 - lon2
  var radtheta = Math.PI * theta / 180
  var dist = Math.sin(radlat1) * Math.sin(radlat2) + Math.cos(radlat1) * Math.cos(radlat2) * Math.cos(radtheta)
  dist = Math.acos(dist)
  dist = dist * 180 / Math.PI
  dist = dist * 60 * 1.1515
  if (unit === 'K') { dist = dist * 1.609344 }
  if (unit === 'N') { dist = dist * 0.8684 }
  return dist.toFixed(1)
}

function capitalize (string) {
  return string.charAt(0).toUpperCase() + string.slice(1)
}

function parseEventData (obj) {
  var e = obj.attributes
  e.participants = obj.relationships.participants.data
  e['id'] = obj.id
  e.hostFirstName = capitalize(e.hostFirstName)
  e.hostFuzzyLatitude = parseFloat(e.hostFuzzyLatitude)
  e.hostFuzzyLongitude = parseFloat(e.hostFuzzyLongitude)
  e.activityName = e.activityNames.length > 0 && e.activityNames[0]
  e.food = e.foods.length > 0 && e.foods[0]
  return e
}
