// wrapper around api calls.
// errors are propagated
// additional functionality should be in src/mixins/stars/js
//

import axios from 'axios'
import normalize from 'json-api-normalizer'
import { createUser } from '@/utils/createUser'

export function unstarUser (userId) {
  return axios.delete(`api/users/${userId}/stars`).then(res => {
    return createUser(normalize(res.data))
  })
}

export async function starUser (userId) {
  return axios.post(`api/users/${userId}/stars`).then(res => {
    return createUser(normalize(res.data))
  })
}

export async function undarkStarUser (userId) {
  const res = await axios.delete(`api/users/${userId}/dark_stars`)
  return createUser(normalize(res.data))
}

export async function darkStarUser (userId) {
  const res = await axios.post(`api/users/${userId}/dark_stars`)
  return createUser(normalize(res.data))
}
