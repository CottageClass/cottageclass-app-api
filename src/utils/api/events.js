import axios from 'axios'
import normalize from 'json-api-normalizer'

import { capitalize } from '@/utils/utils'
import { createEvent, createEvents } from '../createEvent'
import Logger from '@/utils/logger'

const logger = Logger('api:events')

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
    logger.logError(e)
    throw e
  }
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
      const events = Object.values(normedData.event).map(parseEventData)
      return events.map(e => {
        return { event: e, user: e.host }
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

function parseEventData (obj) {
  var e = obj.attributes
  e.participants = obj.relationships.participants.data
  e['id'] = obj.id
  e.hostFirstName = capitalize(e.hostFirstName)
  e.hostFuzzyLatitude = parseFloat(e.hostFuzzyLatitude)
  e.hostFuzzyLongitude = parseFloat(e.hostFuzzyLongitude)
  if (e.host && e.host.data) {
    e.host = e.host.data.attributes
  }
  return e
}
