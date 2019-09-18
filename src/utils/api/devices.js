import axios from 'axios'

import Logger from '@/utils/logger'
const logger = Logger('api:devices')

export async function createDevice (data) {
  return axios.post(
    `/api/devices`, data
  ).then(res => {
    logger.log(res)
    return res
  })
}
