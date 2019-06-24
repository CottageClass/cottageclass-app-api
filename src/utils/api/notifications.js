import axios from 'axios'

import Logger from '@/utils/logger'
const logger = Logger('api:notifications')

export function submitNotification (participantId, notificationBodyText) {
  if (process.env.NODE_ENV === 'development') {
    logger.log('NOT SENDING NOTIFICATION to ' + participantId)
    logger.log('MESSAGE: ', notificationBodyText)
    return
  }
  let notificationData = {
    'notification': {
      'body': notificationBodyText
    }
  }
  return axios.post(
    `/api/users/${participantId}/notifications/`, notificationData
  ).then(res => {
    logger.log('NOTIFICATION submission SUCCESS')
    return res
  }).catch(err => {
    logger.logError('NOTIFICATION submission FAILURE')
    logger.logError(err)
    throw err
  })
}
