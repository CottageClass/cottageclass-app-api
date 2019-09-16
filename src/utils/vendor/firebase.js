import * as firebase from 'firebase/app'
import 'firebase/messaging'

import Logger from '@/utils/logger'
import { submitUserInfo } from '@/utils/api'

const logger = Logger('firebase')

async function sendTokenToServer (userId, refreshToken) {
  try {
    await submitUserInfo(userId, { firebaseToken: refreshToken })
  } catch (e) {
    logger.logError('Unable to update token on server')
  }
}

export default {

  init (userId) {
    const messaging = firebase.messaging()
    logger.log('initializing firebase token handling')

    // get a token if it exists
    messaging.getToken().then((currentToken) => {
      if (currentToken) {
        sendTokenToServer(userId, currentToken)
      } else {
        logger.log('No Instance ID token available. Request permission to generate one.')
      }
    }).catch((err) => {
      logger.logError('An error occurred while retrieving token. ', err)
    })

    // register for updates to token
    messaging.onTokenRefresh(async () => {
      try {
        this.refreshedToken = await messaging.getToken()
        logger.log('Token refreshed.')
      } catch (error) {
        logger.error('failed to send token to server')
      }
      try {
        await sendTokenToServer(userId, this.refreshedToken)
      } catch (err) {
        logger.error('Unable to retrieve refreshed token ', err)
      }
    })
  }
}
