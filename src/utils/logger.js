
/*
* logger.
* usage :
* import Logger from '@/utils/logger'
* logger = Logger('myLocalNamespace')
* logger.log('hello')
* logger.logError('oh no!')
* logger.debug will only show in 'test' and 'development' environment
* logger.log and logger.logError will use fullstory in production.
* logger.log and logger.logError will show in development.
* logger.log and logger.logError will not show in test.
*/

import debug from 'debug'
let FS = window.FS

export default function (namespace) {
  const namespacedLog = debug('kidsclub:' + namespace)
  const namespacedError = debug('kidsclub:' + namespace + ':error')

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
          if (FS && FS.log) {
            FS.log(msg)
          } else {
            FS = window.FS
          }
          break
        default:
          break
      }
    },
    logError (msg) {
      switch (process.env.NODE_ENV) {
        case 'development':
        case 'staging':
          namespacedError(msg)
          break
        case 'test':
          break
        case 'production':
          if (FS && FS.log) {
            FS.log('error', msg)
          } else {
            FS = window.FS
          }
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
