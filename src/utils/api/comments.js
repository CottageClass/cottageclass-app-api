import axios from 'axios'
import normalize from 'json-api-normalizer'

import Logger from '@/utils/logger'
import { createComments, createComment } from '@/utils/createComment'

const logger = Logger('api:events')

export const fetchComments = async (userGroupId) => {
  try {
    const res = await axios.get(`/api/user_groups/${userGroupId}/comments`)
    if (res) {
      return createComments(normalize(res.data))
    } else {
      throw Error('failed to fetch comments')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}

export const postComment = async (userGroupId, content) => {
  try {
    const res = await axios.post(`/api/user_groups/${userGroupId}/comments`, { content })
    if (res) {
      return createComment(normalize(res.data))
    } else {
      throw Error('failed to post comment')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}
