import axios from 'axios'
import normalize from 'json-api-normalizer'

import Logger from '@/utils/logger'
const logger = Logger('api:events')

export const fetchPlace = async (id) => {
  try {
    const res = await axios.get(`/api/places/${id}`)
    if (res) {
      return normalize(res.data)
    } else {
      throw Error('failed to fetch place')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}

export const updatePlace = async (id, data) => {
  try {
    const res = await axios.put(
      `/api/places/${id}`,
      data
    )
    if (res) {
      return normalize(res.data)
    } else {
      throw Error('failed to submit message')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}
