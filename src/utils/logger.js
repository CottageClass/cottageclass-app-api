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

let FS = window.FS

export default function (namespace) {
  const namespacedLog = (msgs) => {
    if (msgs.length === 1 && typeof msgs[0] === 'object') {
      console.log('%c Lilypad:' + namespace + ':',
        'color: #00f; font-weight: bold;')
      console.log(msgs[0])
    } else {
      console.log('%c Lilypad:' + namespace + ': %c' + msgs.join(', '),
        'color: #00f; font-weight: bold;',
        'color #000')
    }
  }

  const namespacedError = (msgs) => {
    if (msgs.length === 1 && msgs[0] instanceof Error) {
      console.log('%c Lilypad:' + namespace + ':error:',
        'color: #000; background: #f55;')
      console.log(msgs[0].message)
      console.log(msgs[0].stack)
    } else if (msgs.length === 1 && typeof msgs[0] === 'object') {
      console.log('%c Lilypad:' + namespace + ':error:',
        'color: #000; background: #f55;')
      console.log(msgs[0])
    } else {
      console.log('%c Lilypad:' + namespace + ':error' + ': %c' + msgs.join(', '),
        'color: #000; background: #f55;',
        'color #fff')
    }
  }

  return {
    log (...msg) {
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
    logError (...msg) {
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

    debug (...msg) {
      switch (process.env.NODE_ENV) {
        case 'development':
        case 'staging':
        case 'test':
          namespacedLog(msg)
          break
        default:
          break
      }
    }
  }
}
