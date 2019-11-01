import * as firebase from 'firebase/app'
import 'firebase/messaging'

import Logger from '@/utils/logger'
import { createDevice } from '@/utils/api'

const logger = Logger('firebase')

async function sendTokenToServer (userId, refreshToken) {
  try {
    await createDevice({ token: refreshToken, platform: 'pwa' })
  } catch (e) {
    logger.logError('Unable to update token on server', e)
  }
}

export default {

  init (userId) {
    logger.log('initializing firebase')
    const messaging = firebase.messaging()
    messaging.onMessage((payload) => {
      logger.debug('Message received. ', payload)
    })

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
