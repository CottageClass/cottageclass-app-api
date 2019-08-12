import Logger from '@/utils/logger'
import axios from 'axios'
import normalize from 'json-api-normalizer'
import { createUser } from '@/utils/createUser'
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

export async function undarkStarUser (userId) {
  try {
    const res = await axios.delete(`api/users/${userId}/dark-stars`)
    return createUser(normalize(res.data))
  } catch (e) {
    logger.logError(e)
  }
}

export async function darkStarUser (userId) {
  try {
    const res = await axios.post(`api/users/${userId}/dark-stars`)
    return createUser(normalize(res.data))
  } catch (e) {
    logger.logError(e)
  }
}
