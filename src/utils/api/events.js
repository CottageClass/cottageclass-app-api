import axios from 'axios'
import normalize from 'json-api-normalizer'

import { createEvent, createEvents } from '../createEvent'
import { createItemsFromEvents } from '../createItem'
import Logger from '@/utils/logger'

const logger = Logger('api:events')

export function submitEventSeriesData (data) {
  return axios.post(
    `/api/event_series`, data
  ).then(res => {
    return Object.values(normalize(res.data).eventSeries)[0].relationships.events.data
  })
}
export const fetchEvents = async ({ miles, lat, lng, minAge, maxAge, date, weekday, pageSize = 20, page = 1 }) => {
  let url = `/api/events/upcoming/miles/${miles}/latitude/${lat}/longitude/${lng}/`
  if (minAge || minAge === 0) {
    url += `min_age/${minAge}/`
  }
  if (maxAge || maxAge === 0) {
    url += `max_age/${maxAge}/`
  }
  if (date) {
    url += `date/${date}/`
  } else if (weekday || weekday === 0) {
    url += `weekday/${weekday}/`
  }
  url += 'sort/chronological/'
  url += `page/${page}/page_size/${pageSize}`
  return axios.get(url).then(res => {
    logger.log('FETCH SUCCESS -- ', url)
    logger.log(res.data)
    return createItemsFromEvents(normalize(res.data, { endpoint: 'event' }))
  }).catch(err => {
    logger.logError('FETCH FAILURE -- ', url)
    logger.logError(err.errors)
    throw err
  })
}

export const updateEvent = async (eventId, data) => {
  try {
    const res = axios.put(`/api/events/${eventId}`, data)
    if (res) {
      return createEvent(normalize(res.data))
    } else {
      throw Error('failed to update event')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}

export const fetchEventsByPlace = async (placeId) => {
  placeId = placeId.toString()
  try {
    const res = await axios.get(`/api/places/${placeId}/events/upcoming`)
    if (res) {
      return createEvents(normalize(res.data))
    } else {
      throw Error('failed to fetch events')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
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
    logger.logError(e)
    throw e
  }
}

export function fetchUpcomingParticipatingEvents (userId, pageSize = 100) {
  return axios.get(`/api/users/${userId}/events/participated/upcoming/page/1/page_size/${pageSize}`)
    .then(res => {
      logger.log('GET PARTICIPATING EVENTS SUCCESS')
      logger.log(res)
      const normedData = normalize(res.data)
      if (!normedData.event) {
        return []
      }
      const events = createEvents(normedData)
      return events.map(e => {
        return { event: e, user: e.user }
      })
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
