import Logger from '@/utils/logger'
import axios from 'axios'
const logger = Logger('api:stars')

export async function fetchStarredItems (userId) {
  try {
    return await axios.get(`api/users/${userId}/stars`)
  } catch (e) {
    logger.logError(e)
  }
}

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
