// wrapper around api calls.
// errors are propagated
// additional functionality should be in src/mixins/stars/js
//

import axios from 'axios'
import normalize from 'json-api-normalizer'
import { createUser } from '@/utils/createUser'

export async function unstarEventSeries (eventSeriesId) {
  const res = await axios.delete(`api/event_series/${eventSeriesId}/stars`)
  return normalize(res.data)
}

export async function starEventSeries (eventSeriesId) {
  const res = await axios.post(`api/event_series/${eventSeriesId}/stars`)
  return normalize(res.data)
}

export async function undarkStarUser (userId) {
  const res = await axios.delete(`api/users/${userId}/dark_stars`)
  return createUser(normalize(res.data))
}

export async function darkStarUser (userId) {
  const res = await axios.post(`api/users/${userId}/dark_stars`)
  return createUser(normalize(res.data))
}
