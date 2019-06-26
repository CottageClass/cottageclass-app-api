import axios from 'axios'

import Logger from '@/utils/logger'

const logger = Logger('api:proxy')

export function initProxySession (currentUserId, receiverId, requestMessage, acknowledgmentMessage) {
  logger.log('INITIATING PROXY WITH users ' + currentUserId + ', ' + receiverId)
  if (process.env.NODE_ENV === 'development') {
    logger.log('NOT SENDING NOTIFICATION from ' + currentUserId + '.  To: ' + receiverId)
    logger.log('REQUEST MESSAGE: ' + requestMessage)
    logger.log('ACKNOWLEDGE MESSAGE: ' + acknowledgmentMessage)
    return new Promise((resolve, reject) => {
      resolve()
    })
  }
  let postData = { twilioSession: { requestMessage, acknowledgmentMessage } }

  return axios.post(
    `/users/${receiverId}/proxy_sessions`,
    postData
  ).then(res => {
    logger.log('proxy session init SUCCESS, returning proxy phone number for receiver')
    // return proxy number for receiver
    return res.data.data.attributes.proxyIdentifierReceiver
  }).catch(err => {
    logger.logError('proxy session init FAILURE')
    logger.logError(err)
    throw err
  })
}
