
/*
* logger.
* usage :
* import Logger from '@/utils/logger'
* logger = Logger('myLocalNamespace')
* logger.log('hello')
* logger.error('oh no!')
* logger.debug will only show in 'test' and 'development' environment
* logger.log and logger.error will use fullstory in production.
* logger.log and logger.error will show in development.
* logger.log and logger.error will not show in test.
*/

import debug from 'debug'
const FS = window.FS

export default function (namespace) {
  const namespacedLog = debug(namespace)
  const namespacedError = debug(namespace + ':error')

  return {
    log (msg) {
      switch (process.env.NODE_ENV) {
        case 'development':
        case 'staging':
          namespacedLog(msg)
          break
        case 'test':
          break
        case 'production':
          FS.log(msg)
          break
        default:
          break
      }
    },
    error (msg) {
      switch (process.env.NODE_ENV) {
        case 'development':
        case 'staging':
          namespacedError(msg)
          break
        case 'test':
          break
        case 'production':
          FS.error(msg)
          break
        default:
          break
      }
    },

    debug (msg) {
      switch (process.env.NODE_ENV) {
        case 'development':
        case 'staging':
          namespacedLog(msg)
          break
        case 'test':
          namespacedLog(msg)
          break
        case 'production':
          break
        default:
          break
      }
    }
  }
}
