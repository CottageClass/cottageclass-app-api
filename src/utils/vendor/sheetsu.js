import moment from 'moment'
import sheetsu from 'sheetsu-node'
import Logger from '@/utils/logger'

const logger = Logger('vendor:sheetsu')
const client = sheetsu({ address: 'https://sheetsu.com/apis/v1.0su/62cd725d6088' })

export function submitToSheetsu (data, sheetName) {
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
}
