import camelcaseKeys from 'camelcase-keys'
import normalize from 'json-api-normalizer'
import axios from 'axios'
import { createEvent, createEvents } from '../createEvent'
import { createUser, createUsers } from '../createUser'
import { capitalize } from '@/utils/utils'
import Logger from '@/utils/logger'

export * from './stars'
export * from './search'
export * from './auth'

const logger = Logger('api')

export function initProxySession (currentUserId, receiverId, requestMessage, acknowledgmentMessage) {
  logger.log('INITIATING PROXY WITH users ' + currentUserId + ', ' + receiverId)
  if (process.env.NODE_ENV === 'development') {
    logger.log('NOT SENDING NOTIFICATION from ' + currentUserId + '.  To: ' + receiverId)
    logger.log('REQUEST MESSAGE: ', requestMessage)
    logger.log('ACKNOWLEDGE MESSAGE: ', acknowledgmentMessage)
    return new Promise((resolve, reject) => {
      resolve()
    })
  }
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
    logger.log('proxy session init SUCCESS, returning proxy phone number for receiver')
    // return proxy number for receiver
    return res.data.data.attributes.proxyIdentifierReceiver
  }).catch(err => {
    logger.logError('proxy session init FAILURE')
    logger.logError(err)
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
  if (data.hasPet) {
    postData.hasPet = data.hasPet
  }
  if (data.houseRules) {
    postData.houseRules = data.houseRules
  }
  if (data.petDescription) {
    postData.petDescription = data.petDescription
  }

  return axios.post(
    `/users/${userId}`,
    postData
  ).then(res => {
    logger.log('SUBMIT USER SUCCESS', res)
    return res
  }).catch(err => {
    logger.logError('SUBMIT USER FAILURE', err)
    throw err
  })
}

export async function fetchUser (userId) {
  try {
    const res = await axios.get(`/api/users/${userId}`)
    logger.log('FETCH PUBLIC USER #' + userId + ' SUCCESS')
    return createUser(normalize(res.data))
  } catch (err) {
    logger.logError('FETCH PUBLIC USER #' + userId + ' FAILURE')
    logger.logError(err.errors)
    throw err
  }
}

// Private
export async function fetchCurrentUser (userId) {
  try {
    const res = await axios.get(`/api/users/${userId}`)
    logger.log('FETCH PRIVATE USER #' + userId + ' SUCCESS')
    logger.log(res)
    return createUser(normalize(res.data))
  } catch (err) {
    logger.logError('FETCH PRIVATE USER #' + userId + ' FAILURE')
    logger.logError(err.errors)
    throw err
  }
}

export async function fetchFacebookImages (facebookAccessToken) {
  try {
    const res = await axios.get(`https://graph.facebook.com/me/photos?fields=images&access_token=${facebookAccessToken}`)
    return res.data.data
  } catch (e) {
    logger.logError(e)
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
    logger.log('SUBMIT EMERGENCY CONTACTS SUCCESS', res)
  }).catch(err => {
    logger.logError('SUBMIT EMERGENCY CONTACTS FAILURE', childId, arrayOfContacts)
    throw err
  })
}

// backend requires user to be an admin
export function fetchAllUsers () {
  return axios.get(
    `/users`
  ).then(res => {
    logger.log('FETCH ALL USERS SUCCESS')
    return createUsers(normalize(res.data))
  }).catch(err => {
    logger.logError('FETCH ALL USERS FAILURE')
    logger.logError(err.errors)
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
    logger.log('FETCH Messages for User Pair SUCCESS')
    logger.log(createMessagesObject(res.data.data))
    return createMessagesObject(res.data.data)
  }).catch(err => {
    logger.logError('FETCH Messages for User Pair FAILURE')
    logger.logError(err)
    throw err
  })
}

/*
 * NOTIFICATIONS
 */

export function submitNotification (participantId, notificationBodyText) {
  if (process.env.NODE_ENV === 'development') {
    logger.log('NOT SENDING NOTIFICATIO to ' + participantId)
    logger.log('MESSAGE: ', notificationBodyText)
    return
  }
  let notificationData = {
    'notification': {
      'body': notificationBodyText
    }
  }
  return axios.post(
    `/api/users/${participantId}/notifications/`, notificationData
  ).then(res => {
    logger.log('NOTIFICATION submission SUCCESS')
    return res
  }).catch(err => {
    logger.logError('NOTIFICATION submission FAILURE')
    logger.logError(err)
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
    logger.log('FETCH UPCOMING EVENTS SUCCESS')
    return createEvents(normalize(res.data), sortBy)
  }).catch(err => {
    logger.logError('FETCH UPCOMING EVENTS FAILURE')
    logger.logError(err.errors)
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
    logger.log('FETCH SUCCESS -- ', url)
    logger.log(res.data)
    return createEvents(normalize(res.data), sortBy)
  }).catch(err => {
    logger.logError('FETCH FAILURE -- ', url)
    logger.logError(err.errors)
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

export function fetchUpcomingEventsWithinDistance ({ miles, lat, lng, minAge, maxAge, pageSize = 100, page = 1 }) {
  let url = `upcoming/miles/${miles}/latitude/${lat}/longitude/${lng}/`
  if (minAge !== null && typeof minAge !== 'undefined') {
    url += `min_age/${minAge}/`
  }
  if (maxAge !== null && typeof minAge !== 'undefined') {
    url += `max_age/${maxAge}/`
  }
  url += `page/${page}/page_size/${pageSize}`
  return fetchEvents(
    url,
    e => e.startsAt
  )
}

export function fetchUpcomingParticipatingEvents (userId) {
  return axios.get(`/api/users/${userId}/events/participated/upcoming/page/1/page_size/100`)
    .then(res => {
      logger.log('GET PARTICIPATING EVENTS SUCCESS')
      logger.log(res)
      const normedData = normalize(res.data)
      if (!normedData.event) {
        return []
      }
      return Object.values(normedData.event).map(parseEventData)
    }).catch(err => {
      logger.logError('GET PARTICIPATING EVENTS FAILURE')
      logger.logError(err)
      throw err
    })
}

export function removeEventParticipant (eventId) {
  return axios.delete(`/api/events/${eventId}/participants`)
    .then(res => {
      logger.log('REMOVE EVENT PARTICIPANT SUCCESS')
      logger.log(res)
      return res
    })
    .catch(err => {
      logger.logError('REMOVE EVENT PARTICIPANT FAILURE')
      logger.logError(err)
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
      logger.log('SUBMIT EVENT PARTICIPANT SUCCESS')
      logger.log(res)
      return res
    })
    .catch(err => {
      logger.logError('SUBMIT EVENT PARTICIPANT FAILURE')
      logger.logError(err)
      throw err
    })
}

export function deleteEvent (eventId, successCallback) {
  return axios.delete(`/api/events/${eventId}`)
    .then(res => {
      logger.log('DELETE EVENT SUCCESS')
      logger.log(res)
      successCallback()
    })
    .catch(err => {
      logger.logError('DELETE EVENT FAILURE')
      logger.logError(err)
      throw err
    })
}

/*
 * UTILS
 */

function parseEventData (obj) {
  var e = obj.attributes
  e.participants = obj.relationships.participants.data
  e['id'] = obj.id
  e.hostFirstName = capitalize(e.hostFirstName)
  e.hostFuzzyLatitude = parseFloat(e.hostFuzzyLatitude)
  e.hostFuzzyLongitude = parseFloat(e.hostFuzzyLongitude)
  e.activityName = e.activityNames.length > 0 && e.activityNames[0]
  e.food = e.foods.length > 0 && e.foods[0]
  if (e.host && e.host.data) {
    e.host = e.host.data.attributes
  }
  return e
}
