import Logger from '@/utils/logger'
import axios from 'axios'
const logger = Logger('api:stars')

export async function unstarUser (userId) {
  try {
    return await axios.delete(`api/users/${userId}/stars`)
  } catch (e) {
    logger.logError(e)
  }
}

export async function starUser (userId) {
  try {
    return await axios.post(`api/users/${userId}/stars`)
  } catch (e) {
    logger.logError(e)
  }
}

export async function unstarEvent (eventId) {
  try {
    return await axios.delete(`api/events/${eventId}/stars`)
  } catch (e) {
    logger.logError(e)
  }
}

export async function starEvent (eventId) {
  try {
    return await axios.post(`api/events/${eventId}/stars`)
  } catch (e) {
    logger.logError(e)
  }
}
