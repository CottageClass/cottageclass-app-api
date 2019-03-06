import Vue from 'vue'
import camelcaseKeys from 'camelcase-keys'
// import * as Token from './tokens.js'
import normalize from 'json-api-normalizer'

// var moment = require('moment')

/*
 * PROXY SESSIONS
 */
export function initProxySession (currentUserId, receiverId, requestMessage, acknowledgmentMessage) {
  console.log('INITIATING PROXY WITH users ' + currentUserId + ', ' + receiverId)
  let postData = {
    twilioSession: {
      requestMessage: requestMessage,
      acknowledgmentMessage: acknowledgmentMessage
    }
  }
  return Vue.axios.post(
    `${process.env.BASE_URL_API}/users/${receiverId}/proxy_sessions`,
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

export function submitUserInfo (userId, phone, location, availability, children, userObj) {
  console.log('attempting to submit', userId, phone, location, availability, children)

  let postData = {
    networkCode: 'brooklyn-events' // this is hardcoded until we make it unnecessary.
    //        profileBlurb: this.blurb.text,
  }

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
  let childrenAttributes = []
  if (children && children.list && children.list.length > 0) {
    childrenAttributes = children.list.map(function (childAttrs) {
      return {
        ...childAttrs,
        parentId: userId
      }
    })
  }

  if (availability) {
    postData = {
      ...postData,
      ...availability
    }
  }

  if (children && children.list && children.list.length > 0) {
    postData.childrenAttributes = childrenAttributes
  }

  if (userObj && userObj.employer) {
    postData.employer = userObj.employer
  }

  if (userObj && userObj.jobPosition) {
    postData.jobPosition = userObj.jobPosition
  }

  if (userObj && userObj.profileBlurb) {
    postData.profileBlurb = userObj.profileBlurb
  }

  if (userObj && userObj.images) {
    postData.images = userObj.images
  }

  if (userObj && userObj.activities) {
    postData.activities = userObj.activities
  }

  if (userObj && userObj.languages) {
    postData.languages = userObj.languages
  }

  console.log('postdata', postData)
  return Vue.axios.post(
    `${process.env.BASE_URL_API}/users/${userId}`,
    postData
  ).then(res => {
    console.log('SUBMIT USER SUCCESS', res)
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
    firstName: p.first_name,
    lastInitial: p.last_name && p.last_name[0],
    avatar: p.avatar,
    activities: activities,
    availableMornings: p.available_mornings,
    availableEvenings: p.available_evenings,
    availableAfternoons: p.available_afternoons,
    availableWeekends: p.available_weekends,
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
    networkCode: 'brooklyn-events',
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

export function fetchUsersWithinDistance (miles, lat, lon) {
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/api/users/miles/${miles}/latitude/${lat}/longitude/${lon}/page/1/page_size/10`
  ).then(res => {
    console.log('FETCH USERS WITHIN DISTANCE SUCCESS')
    console.log(res.data)
    return createPeopleObject(res.data)
  }).catch(err => {
    console.log('FETCH USERS WITHIN DISTANCE FAILURE')
    console.log(err.errors)
    throw err
  })
}

export function fetchUsersInNetwork (networkId) {
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/networks/${networkId}/users`
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
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/users/${currentUserId}/inquiries`
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

// same as above but using 'normalize' json normalizer to correctly extract children
// uses old API endpoint. todo: modify backend to provide all current user information if the current user themself is requesting it, then switch this to use newer /api/users/:id endpoint.
export function fetchCurrentUser (userId) {
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/users/${userId}`
  ).then(res => {
    console.log('FETCH CURRENT USER SUCCESS')
    console.log(res)
    let normalizedData = normalize(res.data)
    let user = normalizedData.user[userId].attributes
    user.hasAllRequiredFields = user.phone && user.latitude && user.longitude
    user.networkCode = 'brooklyn-events' // give everyone the new network code
    if ('child' in normalizedData) {
      let childrenById = normalizedData.child
      let childIds = Object.keys(childrenById)
      let generateChild = function (aChildId) {
        let child = childrenById[aChildId].attributes
        child.id = aChildId
        child.emergencyContacts = childrenById[aChildId].relationships.emergencyContacts.data
        child.firstName = capitalize(child.firstName)
        return child
      }
      user.children = childIds.map(generateChild)
    } else {
      user.children = []
    }
    user.id = userId
    return user
  }).catch(err => {
    console.log('FETCH CURRENT USER FAILURE')
    console.log(err.errors)
    throw err
  })
}

// uses more recent API endpoint which for now only provides public user information

export function fetchUser (userId) {
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/api/users/${userId}`
  ).then(res => {
    console.log('FETCH USER #' + userId + ' SUCCESS')
    console.log(res)
    let normalizedData = normalize(res.data)
    let user = normalizedData.user[userId].attributes
    user.networkCode = 'brooklyn-events' // give everyone the new network code
    user.id = userId
    return user
  }).catch(err => {
    console.log('FETCH USER #' + userId + ' FAILURE')
    console.log(err.errors)
    throw err
  })
}

/*
 * CHILDREN
 */

export function submitEmergencyContacts (childId, arrayOfContacts) {
  return Vue.axios.put(
    `${process.env.BASE_URL_API}/api/user/children/${childId}`,
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
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/users`
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
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/users/${participantId1}/messages/${participantId2}`
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
  return Vue.axios.post(
    `${process.env.BASE_URL_API}/api/users/${participantId}/notifications/`, notificationData
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

export function fetchUpcomingEvents (userId) {
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/api/users/${userId}/events/created/upcoming/page/1/page_size/100`
  ).then(res => {
    console.log('FETCH MY UPCOMING EVENTS SUCCESS')
    return Object.values(normalize(res.data).event).map(parseEventData)
  }).catch(err => {
    console.log('FETCH MY UPCOMING EVENTS FAILURE')
    console.log(err.errors)
    throw err
  })
}

export function submitEventSeriesData (data) {
  return Vue.axios.post(
    `${process.env.BASE_URL_API}/api/event_series`, data
  ).then(res => {
    return Object.values(normalize(res.data).event).map(parseEventData)
  })
}

export function fetchEvents (params) {
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/api/events/${params || ''}`
  ).then(res => {
    console.log('FETCH EVENTS SUCCESS')
    console.log(res.data)
    return Object.values(normalize(res.data).event).map(parseEventData)
  }).catch(err => {
    console.log('FETCH EVENTS FAILURE')
    console.log(err.errors)
    throw err
  })
}

export function fetchUpcomingEventsWithinDistance (miles, lat, lon, sort) {
  return Vue.axios.get(
    `${process.env.BASE_URL_API}/api/events/upcoming/miles/${miles}/latitude/${lat}/longitude/${lon}/sort/chronological`
  ).then(res => {
    console.log('FETCH UPCOMING EVENTS WITHIN DISTANCE SUCCESS')
    console.log(res.data)
    // this seems to reverse list order so we reverse on next line
    let listOfEvents = Object.values(normalize(res.data).event).map(parseEventData)
    return listOfEvents
  }).catch(err => {
    console.log('FETCH UPCOMING EVENTS WITHIN DISTANCE FAILURE')
    console.log(err.errors)
    throw err
  })
}

export function fetchUpcomingParticipatingEvents (userId) {
  return Vue.axios.get(`${process.env.BASE_URL_API}/api/users/${userId}/events/participated/upcoming/page/1/page_size/100`)
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
  return Vue.axios.delete(`${process.env.BASE_URL_API}/api/events/${eventId}/participants`)
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
  return Vue.axios.post(`${process.env.BASE_URL_API}/api/events/${eventId}/participants`, participantData)
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
  return Vue.axios.delete(`${process.env.BASE_URL_API}/api/events/${eventId}`)
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

/*
 * UTILS
 */

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

