import axios from 'axios'
import normalize from 'json-api-normalizer'

import { createConversations } from '../createConversation'
import { createMessages } from '../createMessage'
import Logger from '@/utils/logger'
const logger = Logger('api:events')

export const fetchConversations = async () => {
  try {
    const res = await axios.get(`/api/user/conversations`)
    if (res) {
      return createConversations(normalize(res.data))
    } else {
      throw Error('failed to fetch conversations')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}

export const fetchMessages = async (userId) => {
  try {
    const res = await axios.get(`/api/users/${userId}/messages`)
    if (res) {
      return createMessages(normalize(res.data))
    } else {
      throw Error('failed to fetch conversations')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}
