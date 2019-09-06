import ahoy from 'ahoy.js'
import Logger from '@/utils/logger'
const logger = Logger('ahoy')

export async function trackEvent (name, properties) {
  logger.debug('tracking event')
  logger.debug({ name, properties })
  return ahoy.track(name, properties)
}
