import Logger from '@/utils/logger'
import axios from 'axios'
import normalize from 'json-api-normalizer'
import { createUsers, createUser } from '@/utils/createUser'
const logger = Logger('api:stars')

export async function unstarUser (userId) {
  try {
    const res = await axios.delete(`api/users/${userId}/stars`)
    return createUser(normalize(res.data))
  } catch (e) {
    logger.logError(e)
  }
}

export async function starUser (userId) {
  try {
    const res = await axios.post(`api/users/${userId}/stars`)
    return createUser(normalize(res.data))
  } catch (e) {
    logger.logError(e)
  }
}

export async function fetchStarrers (starable) {
  try {
    const res = await axios.get(`api/events/${starable.eventId}/stars`)
    return createUsers(normalize(res.data))
  } catch (e) {
    logger.logError(e)
  }
}
