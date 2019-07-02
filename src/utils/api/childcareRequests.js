import axios from 'axios'
import Logger from '@/utils/logger'
const logger = Logger('api:childcareRequests')

export async function submitChildcareRequest (description) {
  const data = { 'childcare_request': { content: description } }
  try {
    await axios.post('api/childcare_requests', data)
  } catch (e) {
    logger.logError(e)
  }
}
