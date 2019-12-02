import axios from 'axios'
import normalize from 'json-api-normalizer'

import Logger from '@/utils/logger'
import { createUsers } from '@/utils/createUser'

const logger = Logger('api:events')

export const fetchGroupMembers = async (userGroupId) => {
  try {
    const res = await axios.get(`/api/user_groups/${userGroupId}`)
    if (res) {
      return createUsers(normalize(res.data))
    } else {
      throw Error('failed to fetch comments')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}
