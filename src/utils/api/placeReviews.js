import axios from 'axios'
import normalize from 'json-api-normalizer'

import Logger from '@/utils/logger'
import { createPlaceReview, createPlaceReviews } from '@/utils/createPlaceReview'

const logger = Logger('api:events')

export const postPlaceReview = async ({ placeId, stars, content }) => {
  try {
    const res = await axios.post(`/api/places/${placeId}/place_reviews`, { stars, content })
    if (res) {
      return createPlaceReview(normalize(res.data))
    } else {
      throw Error('failed to post comment')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}

export const fetchPlaceReviews = async (placeId) => {
  try {
    const res = await axios.get(`/api/places/${placeId}/place_reviews`)
    if (res) {
      return createPlaceReviews(normalize(res.data))
    } else {
      throw Error('failed to fetch comments')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}
