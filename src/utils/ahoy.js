import ahoy from 'ahoy.js'
import Logger from '@/utils/logger'
const logger = Logger('ahoy')

export async function trackEvent (name, properties) {
  logger.log('tracking event', { name, properties })
  return ahoy.track(name, properties)
}
