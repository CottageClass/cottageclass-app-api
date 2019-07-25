import moment from 'moment'
import sheetsu from 'sheetsu-node'
import Logger from '@/utils/logger'

const logger = Logger('vendor:sheetsu')
const client = sheetsu({ address: 'https://sheetsu.com/apis/v1.0su/62cd725d6088' })

export function submitToSheetsu (data, sheetName) {
  if (process.env.NODE_ENV === 'production' && !window.location.hostname.includes('staging')) {
    data = { timeStamp: moment(Date()).format('LLLL'), ...data }
    try {
      client.create(data, sheetName)
      logger.log('submitted to sheetsu')
      logger.log('sheet:' + sheetName)
      logger.log(data)
    } catch (e) {
      logger.logError('failed to submit to sheetsu')
      logger.logError(e)
    }
  } else {
    logger.log('current environment is ' + process.env.NODE_ENV)
    logger.log('NOT SENDING SHEETSU DATA to sheet: ' + sheetName)
    logger.log({ data })
  }
}
