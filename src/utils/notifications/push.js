import Logger from '@/utils/logger'
const logger = Logger('notifications:push')

export function requestPermission () {
  if (typeof Notification !== 'undefined') {
    Notification.requestPermission(function (status) {
      logger.debug('Notification permission status:', status)
    })
  }
}
