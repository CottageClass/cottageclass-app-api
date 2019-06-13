import Logger from '@/utils/logger'

const logger = Logger('__mocks__/api')

export async function fetchFeed ({ miles, lat, lng, minAge, maxAge, pageSize = 20, page = 1 }) {
  logger.debug('mocking fetchFeed')
  return []
}
