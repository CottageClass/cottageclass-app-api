import axios from 'axios'
import normalize from 'json-api-normalizer'
import { createChildcareRequest } from '@/utils/createChildcareRequest'

import Logger from '@/utils/logger'
const logger = Logger('api:childcareRequests')

export async function fetchChildcareRequest (id) {
  try {
    const res = await axios.get(`api/childcare_requests/${id}`)
    if (res) {
      return createChildcareRequest(normalize(res.data))
    } else {
      throw Error('failed to fetch childcare request')
    }
  } catch (e) {
    logger.logError(e)
    throw e
  }
}

export async function submitChildcareRequest (description) {
  const data = { 'childcare_request': { content: description } }
  try {
    await axios.post('api/childcare_requests', data)
  } catch (e) {
    logger.logError(e)
    throw e
  }
}
