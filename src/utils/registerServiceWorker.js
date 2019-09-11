import Logger from '@/utils/logger'
import { isIOSNativeApp } from '@/utils/platform'
const logger = Logger('registerServiceWorker')

// this should be called after page load
export function registerServiceWorker () {
  if (isIOSNativeApp() && 'serviceWorker' in navigator) {
    navigator.serviceWorker.register('/service-worker.js').then(function (reg) {
      logger.log('Service Worker Registered!', reg)

      reg.pushManager.getSubscription().then(function (sub) {
        if (sub === null) {
        // Update UI to ask user to register for Push
          logger.log('Not subscribed to push service!')
        } else {
        // We have a subscription, update the database
          logger.log('Subscription object: ')
          logger.log(sub)
        }
      })
    }).catch(function (err) {
      logger.error('Service Worker registration failed: ', err)
    })
  }
}

export function subscribeUser () {
  if ('serviceWorker' in navigator) {
    navigator.serviceWorker.ready.then(function (reg) {
      reg.pushManager.subscribe({
        userVisibleOnly: true
      }).then(function (sub) {
        logger.log('Endpoint URL: ', sub.endpoint)
      }).catch(function (e) {
        if (Notification.permission === 'denied') {
          logger.log('Permission for notifications was denied')
        } else {
          logger.logError(e)
        }
      })
    })
  }
}
