import Logger from '@/utils/logger'
import axios from 'axios'
import normalize from 'json-api-normalizer'
import { createItems } from '@/utils/createItem'
const logger = Logger('api:search')

export async function fetchFeed ({ miles, lat, lng, minAge, maxAge, pageSize = 20, page = 1 }) {
  try {
    let url = `/api/feed/miles/${miles}/latitude/${lat}/longitude/${lng}/`
    if (minAge !== null && typeof minAge !== 'undefined') {
      url += `min_age/${minAge}/`
    }
    if (maxAge !== null && typeof minAge !== 'undefined') {
      url += `max_age/${maxAge}/`
    }
    url += `page/${page}/page_size/${pageSize}`
    const res = await axios.get(url)
    logger.log('FETCH USERS WITHIN DISTANCE SUCCESS')
    logger.log(res.data)
    const normalizedData = normalize(res.data, { endpoint: 'item' })
    return createItems(normalizedData)
  } catch (err) {
    logger.logError('FETCH USERS WITHIN DISTANCE FAILURE')
    logger.logError(err)
    throw err
  }
}
